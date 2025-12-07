from flask import Flask, render_template, request, session, redirect, url_for, jsonify
from flask_session import Session
from werkzeug.security import generate_password_hash
from werkzeug.security import check_password_hash
import gspread
import requests
import json
import time
import uuid
import os
import x 
import dictionary
import io
import csv

from oauth2client.service_account import ServiceAccountCredentials

from icecream import ic
ic.configureOutput(prefix=f'----- | ', includeContext=True)

app = Flask(__name__)

# Set the maximum file size to 10 MB
app.config['MAX_CONTENT_LENGTH'] = 1 * 1024 * 1024   # 1 MB

app.config['SESSION_TYPE'] = 'filesystem'
Session(app)
 

##############################
##############################
##############################
def _____USER_____(): pass 
##############################
##############################
##############################

@app.get("/")
def view_index():
   
    return render_template("index.html")

##############################
@app.context_processor
def global_variables():
    return dict (
        dictionary = dictionary,
        x = x
    )

###testing###
##############################
@app.route("/login", methods=["GET", "POST"])
@app.route("/login/<lan>", methods=["GET", "POST"])
@x.no_cache
def login(lan = "english"):

    if lan not in x.allowed_languages: lan = "english"
    x.default_language = lan

    if request.method == "GET":
        if session.get("user", ""): return redirect(url_for("home"))
        return render_template("login.html", lan=lan)

    if request.method == "POST":
        try:
            # Validate           
            user_email = x.validate_user_email(lan)
            user_password = x.validate_user_password(lan)
            # Connect to the database
            q = "SELECT * FROM users WHERE user_email = %s"
            db, cursor = x.db()
            cursor.execute(q, (user_email,))
            user = cursor.fetchone()

            # Specific error for when a user is not found 
            if not user:
                raise Exception(x.lans("user_not_found"), 400)

            # invalid credentials as a key for not repeating as much 
            invalid_credentials_msg = x.lans("invalid_credentials")
            if not check_password_hash(user["user_password"], user_password):
                raise Exception(invalid_credentials_msg, 400)

            # error for when user not verified 
            if user["user_verification_key"] != "":
                raise Exception(x.lans("user_not_verified"), 400)

            user.pop("user_password")

            session["user"] = user
            return f"""<browser mix-redirect="/home"></browser>"""

        except Exception as ex:
            ic(ex)

            # User errors
            if ex.args[1] == 400:
                toast_error = render_template("___toast_error.html", message=ex.args[0])
                return f"""<browser mix-update="#toast">{ toast_error }</browser>""", 400

            # System or developer error
            toast_error = render_template("___toast_error.html", message="System under maintenance")
            return f"""<browser mix-bottom="#toast">{ toast_error }</browser>""", 500

        finally:
            if "cursor" in locals(): cursor.close()
            if "db" in locals(): db.close()




##############################
@app.route("/signup", methods=["GET", "POST"])
@app.route("/signup/<lan>", methods=["GET", "POST"])
def signup(lan = "english"):

    if lan not in x.allowed_languages: lan = "english"
    x.default_language = lan

    if request.method == "GET":
        return render_template("signup.html", lan=lan)

    if request.method == "POST":
        try:
            # Validate
            user_email = x.validate_user_email()
            user_password = x.validate_user_password()
            user_username = x.validate_user_username()
            user_first_name = x.validate_user_first_name()

            user_pk = uuid.uuid4().hex
            user_last_name = ""
            user_avatar_path = None
            user_verification_key = uuid.uuid4().hex
            user_verified_at = 0

            user_hashed_password = generate_password_hash(user_password)

            # Connect to the database
            q = "INSERT INTO users VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s)"
            db, cursor = x.db()
            cursor.execute(q, (user_pk, user_email, user_hashed_password, user_username, 
            user_first_name, user_last_name, user_avatar_path, user_verification_key, user_verified_at))
            db.commit()

            # send verification email
            email_verify_account = render_template("_email_verify_account.html", user_verification_key=user_verification_key)
            ic(email_verify_account)
            x.send_email(user_email, "Verify your account", email_verify_account)

            return f"""<mixhtml mix-redirect="{ url_for('login') }"></mixhtml>""", 400
        except Exception as ex:
            ic(ex)
            # User errors
            if ex.args[1] == 400:
                toast_error = render_template("___toast_error.html", message=ex.args[0])
                return f"""<mixhtml mix-update="#toast">{ toast_error }</mixhtml>""", 400
            
            # Database errors
            if "Duplicate entry" and user_email in str(ex): 
                toast_error = render_template("___toast_error.html", message="Email already registered")
                return f"""<mixhtml mix-update="#toast">{ toast_error }</mixhtml>""", 400
            if "Duplicate entry" and user_username in str(ex): 
                toast_error = render_template("___toast_error.html", message="Username already registered")
                return f"""<mixhtml mix-update="#toast">{ toast_error }</mixhtml>""", 400
            
            # System or developer error
            toast_error = render_template("___toast_error.html", message="System under maintenance")
            return f"""<mixhtml mix-bottom="#toast">{ toast_error }</mixhtml>""", 500

        finally:
            if "cursor" in locals(): cursor.close()
            if "db" in locals(): db.close()



##############################
@app.get("/home")
@x.no_cache
def home():
    try:
        user = session.get("user", "")
        if not user: 
            return redirect(url_for("login"))

        db, cursor = x.db()

        # Load tweets with info about whether current user has liked and total like count
        # NEED FURTHER EXPLANATION FOR THIS QUERY FROM SANTIAGO ( LITTLE CHAT HELP WITH THIS ONE)
        q = """
        SELECT
            users.*,
            posts.*,
            EXISTS(
                SELECT 1 
                FROM likes 
                WHERE likes.like_post_fk = posts.post_pk 
                  AND likes.like_user_fk = %s
            ) AS has_liked,
            (
                SELECT COUNT(*) 
                FROM likes 
                WHERE likes.like_post_fk = posts.post_pk
            ) AS like_count
        FROM users
        JOIN posts ON user_pk = post_user_fk
        WHERE posts.post_deleted_at IS NULL
        ORDER BY RAND()

        LIMIT 5
        """
        cursor.execute(q, (user["user_pk"],))
        tweets = cursor.fetchall()
        ic(tweets)

        # Fetch comments for each tweet with user info
        for tweet in tweets:
            q_comments = """
            SELECT 
                comment.*,
                users.user_first_name,
                users.user_last_name,
                users.user_username,
                users.user_avatar_path
            FROM comment
            JOIN users ON comment.comment_user_fk = users.user_pk
            WHERE comment.comment_post_fk = %s 
              AND comment.comment_deleted_at IS NULL
            ORDER BY comment.comment_created_at DESC
            LIMIT 3
            """
            cursor.execute(q_comments, (tweet["post_pk"],))
            tweet["comments"] = cursor.fetchall()

        q = "SELECT * FROM trends ORDER BY RAND() LIMIT 3"
        cursor.execute(q)
        trends = cursor.fetchall()
        ic(trends)
        # NEED FURTHER EXPLANATION FOR THIS QUERY FROM SANTIAGO ( LITTLE CHAT HELP WITH THIS ONE)
        q = """
        SELECT 
            users.*,
            EXISTS(
                SELECT 1 
                FROM follows 
                WHERE follows.follow_follower_fk = %s 
                  AND follows.follow_following_fk = users.user_pk
                  AND follows.follow_deleted_at IS NULL
            ) AS is_following
        FROM users 
        WHERE user_pk != %s 
        ORDER BY RAND() 
        LIMIT 3
        """
        cursor.execute(q, (user["user_pk"], user["user_pk"]))
        suggestions = cursor.fetchall()
        ic(suggestions)

        return render_template("home.html", tweets=tweets, trends=trends, suggestions=suggestions, user=user)
    except Exception as ex:
        ic(ex)
        return "error"
    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()

##############################
@app.route("/verify-account", methods=["GET"])
def verify_account():
    try:
        user_verification_key = x.validate_uuid4_without_dashes(request.args.get("key", ""))
        user_verified_at = int(time.time())
        db, cursor = x.db()
        q = "UPDATE users SET user_verification_key = '', user_verified_at = %s WHERE user_verification_key = %s"
        cursor.execute(q, (user_verified_at, user_verification_key))
        db.commit()
        if cursor.rowcount != 1: raise Exception("Invalid key", 400)
        return redirect( url_for('login') )
    except Exception as ex:
        ic(ex)
        if "db" in locals(): db.rollback()
        # User errors
        if ex.args[1] == 400: return ex.args[0], 400    

        # System or developer error
        return "Cannot verify user"

    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()

##############################
@app.get("/logout")
def logout():
    try:
        session.clear()
        return redirect(url_for("login"))
    except Exception as ex:
        ic(ex)
        return "error"
    finally:
        pass



# ##############################
# @app.get("/home-comp")
# def home_comp():
#     try:

#         user = session.get("user", "")
#         if not user: 
#             return "error"

#         db, cursor = x.db()
#         q = """
#         SELECT
#             users.*,
#             posts.*,
#             EXISTS(
#                 SELECT 1 
#                 FROM likes 
#                 WHERE likes.like_post_fk = posts.post_pk 
#                   AND likes.like_user_fk = %s
#             ) AS has_liked,
#             (
#                 SELECT COUNT(*) 
#                 FROM likes 
#                 WHERE likes.like_post_fk = posts.post_pk
#             ) AS like_count
#         FROM users
#         JOIN posts ON user_pk = post_user_fk
#         ORDER BY RAND()
#         LIMIT 5
#         """
#         cursor.execute(q, (user["user_pk"],))
#         tweets = cursor.fetchall()
#         ic(tweets)

#         Fetch comments for each tweet with user info
#         for tweet in tweets:
#             q_comments = """
#             SELECT 
#                 comment.*,
#                 users.user_first_name,
#                 users.user_last_name,
#                 users.user_username,
#                 users.user_avatar_path
#             FROM comment
#             JOIN users ON comment.comment_user_fk = users.user_pk
#             WHERE comment.comment_post_fk = %s 
#               AND comment.comment_deleted_at IS NULL
#             ORDER BY comment.comment_created_at DESC
#             LIMIT 3
#             """
#             cursor.execute(q_comments, (tweet["post_pk"],))
#             tweet["comments"] = cursor.fetchall()

#         html = render_template("_home_comp.html", tweets=tweets)
#         return f"""<mixhtml mix-update="main">{ html }</mixhtml>"""
#     except Exception as ex:
#         ic(ex)
#         return "error"
#     finally:
#         pass


##############################
@app.get("/profile")
def profile():
    try:
        user = session.get("user", "")
        if not user: return "error"
        q = "SELECT * FROM users WHERE user_pk = %s"
        db, cursor = x.db()
        cursor.execute(q, (user["user_pk"],))
        user = cursor.fetchone()
        profile_html = render_template("_profile.html", x=x, user=user)
        return f"""<browser mix-update="main">{ profile_html }</browser>"""
    except Exception as ex:
        ic(ex)
        return "error"
    finally:
        pass


##############################
@app.delete("/delete-profile")
def delete_profile():
    try:
        user = session.get("user", "")
        if not user: return "error"
        q = "DELETE FROM users WHERE user_pk = %s"
        db, cursor = x.db()
        cursor.execute(q, (user["user_pk"],))
        db.commit()
        session.clear()
        return f"""<browser mix-redirect="{ url_for('login') }"></browser>"""
    except Exception as ex:
        ic(ex)
        if "db" in locals(): db.rollback()
        return "error"
    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()

@app.patch("/like-tweet")
@x.no_cache
def like_tweet():
    try:
        user = session.get("user", "")
        if not user:
            return "invalid user", 401

        post_pk = request.form.get("post_pk", "").strip()
        if not post_pk:
            return "invalid post", 400

        db, cursor = x.db()

        q = """
        INSERT INTO likes (like_user_fk, like_post_fk, like_created_at)
        VALUES (%s, %s, NOW())
        """
        cursor.execute(q, (user["user_pk"], post_pk))

        # Get the updated like count
        q = """
        SELECT COUNT(*) AS total_likes
        FROM likes
        WHERE like_post_fk = %s
        """
        cursor.execute(q, (post_pk,))
        row = cursor.fetchone()
        like_count = row["total_likes"] if row else 0

        db.commit()

        # Return a snippet that replaces only this post's like button (black heart)
        button_html = render_template("___button_liked_tweet.html", post_pk=post_pk, like_count=like_count)
        return f"""
            <mixhtml mix-replace="#like_form_{post_pk}">
                {button_html}
            </mixhtml>
        """
    except Exception as ex:
        ic(ex)
        if "db" in locals():
            db.rollback()
        return "error", 500
    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()


##############################
@app.patch("/unlike-tweet")
#means i have fresh data prevents stale responses from the browser, and ensures like count is always current
@x.no_cache
def unlike_tweet():
    try:
        user = session.get("user", "")
        if not user:
            return "invalid user", 401

        post_pk = request.form.get("post_pk", "").strip()
        if not post_pk:
            return "invalid post", 400

        db, cursor = x.db()

        # Hard delete the like
        q = """
        DELETE FROM likes
        WHERE like_user_fk = %s
          AND like_post_fk = %s
        """
        cursor.execute(q, (user["user_pk"], post_pk))

        # Recalculate and update total likes on the post
        q = """
        UPDATE posts
        SET post_total_likes = (
            SELECT COUNT(*)
            FROM likes
            WHERE like_post_fk = %s
        )
        WHERE post_pk = %s
        """
        cursor.execute(q, (post_pk, post_pk))

        # Get the updated like count
        q = """
        SELECT COUNT(*) AS total_likes
        FROM likes
        WHERE like_post_fk = %s
        """
        cursor.execute(q, (post_pk,))
        row = cursor.fetchone()
        like_count = row["total_likes"] if row else 0

        db.commit()

        # Return the "not liked" button with updated count
        button_html = render_template(
            "___button_like_tweet.html",
            post_pk=post_pk,
            like_count=like_count
        )
        return f"""
            <mixhtml mix-replace="#liked_form_{post_pk}">
                {button_html}
            </mixhtml>
        """
    except Exception as ex:
        ic(ex)
        if "db" in locals():
            db.rollback()
        return "error", 500
    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()

##############################
@app.route("/api-create-post", methods=["POST"])
def api_create_post():
    try:
        user = session.get("user", "")
        if not user: return "invalid user"
        user_pk = user["user_pk"]        
        post = x.validate_post(request.form.get("post", ""))
        post_pk = uuid.uuid4().hex
        post_image_path = ""
        db, cursor = x.db()
        q = "INSERT INTO posts (post_pk, post_user_fk, post_message, post_total_likes, post_image_path, post_deleted_at) VALUES(%s, %s, %s, %s, %s, NULL)"
        cursor.execute(q, (post_pk, user_pk, post, 0, post_image_path))
        db.commit()
        toast_ok = render_template("___toast_ok.html", message="The world is reading your post !")
        tweet = {
            "user_first_name": user["user_first_name"],
            "user_last_name": user["user_last_name"],
            "user_username": user["user_username"],
            "user_avatar_path": user["user_avatar_path"],
            "post_message": post,
        }
        html_post_container = render_template("___post_container.html")
        html_post = render_template("_tweet.html", tweet=tweet)
        return f"""
            <browser mix-bottom="#toast">{toast_ok}</browser>
            <browser mix-top="#posts">{html_post}</browser>
            <browser mix-replace="#post_container">{html_post_container}</browser>
        """
    except Exception as ex:
        ic(ex)
        if "db" in locals(): db.rollback()

        # User errors
        if "x-error post" in str(ex):
            toast_error = render_template("___toast_error.html", message=f"Post - {x.POST_MIN_LEN} to {x.POST_MAX_LEN} characters")
            return f"""<browser mix-bottom="#toast">{toast_error}</browser>"""

        # System or developer error
        toast_error = render_template("___toast_error.html", message="System under maintenance")
        return f"""<browser mix-bottom="#toast">{ toast_error }</browser>""", 500

    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()    



##############################
@app.delete("/api-delete-post")
def api_delete_post():
    try:
        user = session.get("user", "")
        if not user:
            return "invalid user", 401

        post_pk = request.args.get("post_pk", "").strip()
        if not post_pk:
            toast_error = render_template("___toast_error.html", message="Invalid post")
            return f"""<browser mix-bottom="#toast">{toast_error}</browser>""", 400
        
        db, cursor = x.db()

        q = "SELECT * FROM posts WHERE post_pk = %s AND post_user_fk = %s AND post_deleted_at IS NULL"
        cursor.execute(q, (post_pk, user["user_pk"]))
        post = cursor.fetchone()

        if not post:
            toast_error = render_template("___toast_error.html", message="Post not found or unauthorized")
            return f"""<browser mix-bottom="#toast">{toast_error}</browser>""", 403

        # Soft delete the post (set post_deleted_at timestamp)
        # Comments and likes remain intact - no need to delete them
        q = "UPDATE posts SET post_deleted_at = NOW() WHERE post_pk = %s AND post_user_fk = %s"
        cursor.execute(q, (post_pk, user["user_pk"]))
        db.commit()

        toast_ok = render_template("___toast_ok.html", message="Post deleted successfully")
        return f"""
            <browser mix-bottom="#toast">{toast_ok}</browser>
            <browser mix-remove="#post_{post_pk}"></browser>
        """, 200

    except Exception as ex:
        ic(ex)
        if "db" in locals(): db.rollback()
        return "error", 500
    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()
################################
@app.route("/api-update-profile", methods=["POST"])
def api_update_profile():

    try:

        user = session.get("user", "")
        if not user: return "invalid user"

        # Validate
        user_email = x.validate_user_email()
        user_username = x.validate_user_username()
        user_first_name = x.validate_user_first_name()

        # Handle avatar upload if provided some chatgpt help with this code. 
        user_avatar_path = None
        avatar_file = x.validate_avatar_upload()
        
        if avatar_file:
            import os
            # Get file extension
            filename = avatar_file.filename.lower()
            ext = os.path.splitext(filename)[1]
            
            # Delete old uploaded avatar if it exists (not external URLs or legacy images)
            old_avatar_path = user.get("user_avatar_path", "")
            if old_avatar_path and old_avatar_path.startswith("uploads/avatars/"):
                old_file_path = os.path.join("static", old_avatar_path)
                if os.path.exists(old_file_path):
                    try:
                        os.remove(old_file_path)
                    except Exception as e:
                        ic(f"Could not delete old avatar: {e}")
            
            # Generate unique filename using user_pk 
            user_avatar_path = f"{user['user_pk']}{ext}"
            upload_path = os.path.join("static", "uploads", "avatars", user_avatar_path)
            
            # Save the file to the uploads folder
            avatar_file.save(upload_path)
            
            # Store relative path in database so it can be retrieved later
            user_avatar_path = f"uploads/avatars/{user_avatar_path}"
        
        if user_avatar_path:
            q = "UPDATE users SET user_email = %s, user_username = %s, user_first_name = %s, user_avatar_path = %s WHERE user_pk = %s"
            db, cursor = x.db()
            cursor.execute(q, (user_email, user_username, user_first_name, user_avatar_path, user["user_pk"]))
            
            # Update session with new avatar path so it can be displayed in the profile page
            user["user_avatar_path"] = user_avatar_path
            session["user"] = user
        else:
            # Update even if no avatar was uploaded
            q = "UPDATE users SET user_email = %s, user_username = %s, user_first_name = %s WHERE user_pk = %s"
            db, cursor = x.db()
            cursor.execute(q, (user_email, user_username, user_first_name, user["user_pk"]))
        
        db.commit()

        # Response to the browser
        toast_ok = render_template("___toast_ok.html", message="Profile updated successfully")
        return f"""
            <browser mix-bottom="#toast">{toast_ok}</browser>
            <browser mix-update="#profile_tag .name">{user_first_name}</browser>
            <browser mix-update="#profile_tag .handle">{user_username}</browser>
            
        """, 200
    except Exception as ex:
        ic(ex)
        # User errors
        if ex.args[1] == 400:
            toast_error = render_template("___toast_error.html", message=ex.args[0])
            return f"""<mixhtml mix-update="#toast">{ toast_error }</mixhtml>""", 400
        
        # Database errors
        if "Duplicate entry" and user_email in str(ex): 
            toast_error = render_template("___toast_error.html", message="Email already registered")
            return f"""<mixhtml mix-update="#toast">{ toast_error }</mixhtml>""", 400
        if "Duplicate entry" and user_username in str(ex): 
            toast_error = render_template("___toast_error.html", message="Username already registered")
            return f"""<mixhtml mix-update="#toast">{ toast_error }</mixhtml>""", 400
        
        # System or developer error
        toast_error = render_template("___toast_error.html", message="System under maintenance")
        return f"""<mixhtml mix-bottom="#toast">{ toast_error }</mixhtml>""", 500

    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()



##############################
@app.post("/api-search")
def api_search():
    try:
        search_for = x.validate_search_for()
        part_of_query = f"%{search_for}%"
        ic(search_for)
        db, cursor = x.db()
        q = "SELECT * FROM users WHERE user_username LIKE %s"
        cursor.execute(q, (part_of_query,))
        users = cursor.fetchall()
        return jsonify(users)
    except Exception as ex:
        ic(ex)
        # User errors
        if len(ex.args) > 1 and ex.args[1] == 400:
            return ex.args[0], 400

        # System or developer error
        return "System under maintenance", 500
    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()



##############################
@app.get("/get-data-from-sheet")
def get_data_from_sheet():
    try:

        # Check if the admin is running this end-point, else show error

        # flaskwebmail
        # Create a google sheet
        # share and make it visible to "anyone with the link"
        # In the link, find the ID of the sheet. Here: 1aPqzumjNp0BwvKuYPBZwel88UO-OC_c9AEMFVsCw1qU
        # Replace the ID in the 2 places bellow
        url= f"https://docs.google.com/spreadsheets/d/{x.google_spread_sheet_key}/export?format=csv&id={x.google_spread_sheet_key}"
        res=requests.get(url=url)
        # ic(res.text) # contains the csv text structure
        csv_text = res.content.decode('utf-8')
        csv_file = io.StringIO(csv_text) # Use StringIO to treat the string as a file
        
        # Initialize an empty list to store the data
        data = {}

        # Read the CSV data
        reader = csv.DictReader(csv_file)
        ic(reader)
        # Convert each row into the desired structure
        for row in reader:
            item = {
                    'english': row['english'],
                    'danish': row['danish'],
                    'spanish': row['spanish']
                
            }
            # Append the dictionary to the list
            data[row['key']] = (item)

        # Convert the data to JSON
        json_data = json.dumps(data, ensure_ascii=False, indent=4) 
        # ic(data)

        # Save data to the file
        with open("dictionary.json", 'w', encoding='utf-8') as f:
            f.write(json_data)

        return "ok"
    except Exception as ex:
        ic(ex)
        return str(ex)
    finally:
        pass
##############################################################
@app.post("/api-follow-user")
def api_follow_user():
    try:
        user = session.get("user", "")
        if not user:
            return "invalid user", 401

        user_pk = user["user_pk"]
        following_user_pk = request.form.get("following_user_pk", "").strip()
        
        if not following_user_pk:
            return "invalid following user", 400
        
        # Prevent self-follow
        if user_pk == following_user_pk:
            return "Cannot follow yourself", 400

        db, cursor = x.db()

        # Validate that the user to follow exists
        q = "SELECT * FROM users WHERE user_pk = %s"
        cursor.execute(q, (following_user_pk,))
        following_user = cursor.fetchone()
        if not following_user:
            return "User not found", 400

        # Check if follow relationship already exists
        q = """
        SELECT * FROM follows 
        WHERE follow_follower_fk = %s 
          AND follow_following_fk = %s
        """
        cursor.execute(q, (user_pk, following_user_pk))
        existing_follow = cursor.fetchone()

        if existing_follow:
            # If already following (not deleted)
            if existing_follow["follow_deleted_at"] is None:
                # Already following, return success (idempotent)
                button_html = render_template("___button_following_user.html", user_pk=following_user_pk)
                return f"""
                    <mixhtml mix-replace="#follow_button_{following_user_pk}">
                        {button_html}
                    </mixhtml>
                """
            else:
                # Re-follow: update the existing record (soft delete reversal)
                q = """
                UPDATE follows 
                SET follow_deleted_at = NULL, 
                    follow_created_at = NOW()
                WHERE follow_follower_fk = %s 
                  AND follow_following_fk = %s
                """
                cursor.execute(q, (user_pk, following_user_pk))
        else:
            # New follow: insert new record
            follow_pk = uuid.uuid4().hex
            q = """
            INSERT INTO follows (follow_pk, follow_follower_fk, follow_following_fk, follow_created_at, follow_deleted_at)
            VALUES (%s, %s, %s, NOW(), NULL)
            """
            cursor.execute(q, (follow_pk, user_pk, following_user_pk))

        db.commit()

        # Return button update (following state)
        button_html = render_template("___button_following_user.html", user_pk=following_user_pk)
        return f"""
            <mixhtml mix-replace="#follow_button_{following_user_pk}">
                {button_html}
            </mixhtml>
        """
    except Exception as ex:
        ic(ex)
        if "db" in locals():
            db.rollback()
        
        # Handle duplicate key error gracefully
        if "Duplicate entry" in str(ex):
            # Already following, return success
            button_html = render_template("___button_following_user.html", user_pk=following_user_pk)
            return f"""
                <mixhtml mix-replace="#follow_button_{following_user_pk}">
                    {button_html}
                </mixhtml>
            """
        
        return "error", 500
    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()

##############################################################
@app.patch("/api-unfollow-user")
def api_unfollow_user():
    try:
        user = session.get("user", "")
        if not user:
            return "invalid user", 401

        user_pk = user["user_pk"]
        following_user_pk = request.form.get("following_user_pk", "").strip()
        
        if not following_user_pk:
            return "invalid following user", 400
        
        # Prevent self-unfollow
        if user_pk == following_user_pk:
            return "Cannot unfollow yourself", 400

        db, cursor = x.db()

        # Validate that the user to unfollow exists
        q = "SELECT * FROM users WHERE user_pk = %s"
        cursor.execute(q, (following_user_pk,))
        following_user = cursor.fetchone()
        if not following_user:
            return "User not found", 400

        # Check if unfollow relationship already exists
        q = """
        SELECT * FROM follows 
        WHERE follow_follower_fk = %s 
          AND follow_following_fk = %s
        """
        cursor.execute(q, (user_pk, following_user_pk))
        existing_follow = cursor.fetchone()

        if existing_follow:
            # If already following (not deleted) - perform soft delete
            if existing_follow["follow_deleted_at"] is None:
                # Soft delete: set follow_deleted_at to NOW()
                q = """
                UPDATE follows 
                SET follow_deleted_at = NOW()
                WHERE follow_follower_fk = %s 
                  AND follow_following_fk = %s
                """
                cursor.execute(q, (user_pk, following_user_pk))

        db.commit()

        # Return button update (following state)
        button_html = render_template("___button_follow_user.html", user_pk=following_user_pk)
        return f"""
            <mixhtml mix-replace="#following_button_{following_user_pk}">
                {button_html}
            </mixhtml>
        """
    except Exception as ex:
        ic(ex)
        if "db" in locals():
            db.rollback()
        return "error", 500
    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()

##############################
@app.post("/api-create-comment")
def api_create_comment():
  try:
    user = session.get("user", "")
    if not user:
      return "invalid user", 401

    post_pk = request.form.get("post_pk", "").strip()
    if not post_pk:
      return "invalid post", 400

    comment_message = request.form.get("comment_message", "").strip()
    if not comment_message:
      return "invalid comment", 400

    comment_pk = uuid.uuid4().hex
    db, cursor = x.db()

    q = """
    INSERT INTO comment (comment_pk, comment_user_fk, comment_post_fk, comment_message, comment_created_at, comment_deleted_at)
    VALUES (%s, %s, %s, %s, NOW(), NULL)
    """
    cursor.execute(q, (comment_pk, user["user_pk"], post_pk, comment_message))
    db.commit()

    # Fetch updated comments with user info
    q_comments = """
    SELECT 
        comment.*,
        users.user_first_name,
        users.user_last_name,
        users.user_username,
        users.user_avatar_path
    FROM comment
    JOIN users ON comment.comment_user_fk = users.user_pk
    WHERE comment.comment_post_fk = %s 
      AND comment.comment_deleted_at IS NULL
    ORDER BY comment.comment_created_at DESC
    LIMIT 3
    """
    cursor.execute(q_comments, (post_pk,))
    comments = cursor.fetchall()

    # Return updated comments HTML // ai helped me with this fase as i could not return the comments to my html for some reason
    comments_html = render_template("_comments.html", comments=comments)
    return f"""
        <browser mix-replace="#comments_list_{post_pk}">
            {comments_html}
        </browser>
    """, 200
  except Exception as ex:
        ic(ex)
        if "db" in locals():
            db.rollback()
        return "error", 500
  finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()
##############################################################
# old version fetching from a api get comment not working 
# @app.get("/api-get-comments")
# def api_get_comments():
#   try:
#     post_pk = request.args.get("post_pk", "").strip()
#     if not post_pk:
#       return "invalid post", 400

#     db, cursor = x.db()

#     q = """
#     SELECT 
#         comment.*,
#         users.user_first_name,
#         users.user_last_name,
#         users.user_username,
#         users.user_avatar_path
#     FROM comment
#     JOIN users ON comment.comment_user_fk = users.user_pk
#     WHERE comment.comment_post_fk = %s 
#       AND comment.comment_deleted_at IS NULL
#     ORDER BY comment.comment_created_at DESC
#     LIMIT 3
#     """
#     cursor.execute(q, (post_pk,))
#     comments = cursor.fetchall()  
#     return render_template("_comments.html", comments=comments)
#   except Exception as ex:
#     ic(ex)
#     return "System under maintenance", 500
#   finally:
#     if "cursor" in locals(): cursor.close()
#     if "db" in locals(): db.close()

