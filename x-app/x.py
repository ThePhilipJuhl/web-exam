from flask import request, make_response, render_template, url_for
import mysql.connector
import re 
import dictionary
import os
import socket

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from functools import wraps

import json
import config


from icecream import ic
ic.configureOutput(prefix=f'----- | ', includeContext=True)

UPLOAD_ITEM_FOLDER = './images'

# Get the directory where this script is located
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

##############################
allowed_languages = ["english", "danish", "spanish"]
google_spread_sheet_key = "1z9MLA8hA2Ry8nnUl3HVk3CvYwLZQoe3ePFwgC_PaLJU"
default_language = "english"

def lans(key):
    dictionary_path = os.path.join(BASE_DIR, "dictionary.json")
    with open(dictionary_path, 'r', encoding='utf-8') as file:
        data = json.load(file)
    return data[key][default_language]

##############################
def is_pythonanywhere():
    """Check if running on PythonAnywhere"""
    hostname = socket.gethostname()
    return 'pythonanywhere' in hostname.lower() or os.environ.get('PYTHONANYWHERE_SITE', '') != ''

##############################
def db():
    try:
        if is_pythonanywhere():
            # PythonAnywhere database configuration
            db = mysql.connector.connect(
                host = "MrPhilipMalik.mysql.eu.pythonanywhere-services.com",
                user = "MrPhilipMalik",  
                password = "mySQLpassword",
                database = "MrPhilipMalik$x"
            )
        else:
            # Local database configuration
            db = mysql.connector.connect(
                host = "mariadb",
                user = "root",  
                password = "password",
                database = "x"
            )
        cursor = db.cursor(dictionary=True)
        return db, cursor
    except Exception as e:
        print(e, flush=True)
        raise Exception("Twitter exception - Database under maintenance", 500)


##############################
def no_cache(view):
    @wraps(view)
    def no_cache_view(*args, **kwargs):
        response = make_response(view(*args, **kwargs))
        response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "0"
        return response
    return no_cache_view


##############################
REGEX_EMAIL = "^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$"
def validate_user_email(lan = "english"):
    user_email = request.form.get("user_email", "").strip()
    if not re.match(REGEX_EMAIL, user_email): raise Exception(f"{ lans('invalid_email') }", 400)
    return user_email

##############################
USER_USERNAME_MIN = 2
USER_USERNAME_MAX = 20
REGEX_USER_USERNAME = f"^.{{{USER_USERNAME_MIN},{USER_USERNAME_MAX}}}$"
def validate_user_username():
    user_username = request.form.get("user_username", "").strip()
    error = f"username min {USER_USERNAME_MIN} max {USER_USERNAME_MAX} characters"
    if len(user_username) < USER_USERNAME_MIN: raise Exception(error, 400)
    if len(user_username) > USER_USERNAME_MAX: raise Exception(error, 400)
    return user_username

##############################
USER_FIRST_NAME_MIN = 2
USER_FIRST_NAME_MAX = 20
REGEX_USER_FIRST_NAME = f"^.{{{USER_FIRST_NAME_MIN},{USER_FIRST_NAME_MAX}}}$"
def validate_user_first_name():
    user_first_name = request.form.get("user_first_name", "").strip()
    error = f"first name min {USER_FIRST_NAME_MIN} max {USER_FIRST_NAME_MAX} characters"
    if not re.match(REGEX_USER_FIRST_NAME, user_first_name): raise Exception(error, 400)
    return user_first_name


##############################
USER_PASSWORD_MIN = 6
USER_PASSWORD_MAX = 50
REGEX_USER_PASSWORD = f"^.{{{USER_PASSWORD_MIN},{USER_PASSWORD_MAX}}}$"
def validate_user_password(lan = "en"):
    user_password = request.form.get("user_password", "").strip()
    if not re.match(REGEX_USER_PASSWORD, user_password): raise Exception(f"{ lans('invalid_password') }", 400)
    return user_password




##############################
def validate_user_password_confirm():
    user_password = request.form.get("user_password_confirm", "").strip()
    if not re.match(REGEX_USER_PASSWORD, user_password): raise Exception("Twitter exception - Invalid confirm password", 400)
    return user_password


##############################
REGEX_UUID4 = "^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
def validate_uuid4(uuid4 = ""):
    if not uuid4:
        uuid4 = request.values.get("uuid4", "").strip()
    if not re.match(REGEX_UUID4, uuid4): raise Exception("Twitter exception - Invalid uuid4", 400)
    return uuid4


##############################
REGEX_UUID4_WITHOUT_DASHES = "^[0-9a-f]{8}[0-9a-f]{4}4[0-9a-f]{3}[89ab][0-9a-f]{3}[0-9a-f]{12}$"
def validate_uuid4_without_dashes(uuid4 = ""):
    error = "Invalid uuid4 without dashes"
    if not uuid4: raise Exception(error, 400)
    uuid4 = uuid4.strip()
    if not re.match(REGEX_UUID4_WITHOUT_DASHES, uuid4): raise Exception(error, 400)
    return uuid4

##############################
POST_MIN_LEN = 2
POST_MAX_LEN = 250
REGEX_POST = f"^.{{{POST_MIN_LEN},{POST_MAX_LEN}}}$"
def validate_post(post = ""):
    post = post.strip()
    if not re.match(REGEX_POST, post): raise Exception("x-error post", 400)
    return post


##############################
def validate_search_for():
    search_for = request.form.get("search_for", "").strip()

    if not search_for:
        raise Exception("empty search", 400)

    if len(search_for) > 20:
        raise Exception("search too long", 400)

    # ONLY ALLOW SIMPLE CHARACTERS NO WILDCARDS 
    if not re.match(r"^[a-zA-Z0-9._\-!@#$%^&*()\\//\"']+$", search_for):
        raise Exception("Invalid characters in search", 400)
    return search_for


##############################

MAX_AVATAR_SIZE = 1 * 1024 * 1024  # 1 MB

def validate_avatar_upload():
    """Validate uploaded avatar file. Returns the file object if valid, None if no file uploaded."""
    if 'user_avatar' not in request.files:
        return None
    
    file = request.files['user_avatar']
    
    # If no file was selected, return None (avatar update is optional)
    if file.filename == '':
        return None
    
    
    return file


##############################
def send_email(to_email, subject, template):
    try:

      #to remember how to do------------
        # Create a gmail fullflaskdemomail
        # Enable (turn on) 2 step verification/factor in the google account manager
        # Visit: https://myaccount.google.com/apppasswords
        # Copy the key : pdru ctfd jdhk xxci
        # Email and password of the sender's Gmail account
        # ---------------------------------


        sender_email = config.EMAIL_KEY
        password = config.EMAIL_KEY_PASS
        receiver_email = to_email
        
        message = MIMEMultipart()
        message["From"] = "X-app"
        message["To"] = to_email
        message["Subject"] = subject

        # Body of the email using a template
        message.attach(MIMEText(template, "html"))

        # Connect to Gmail's SMTP server and send the email
        with smtplib.SMTP("smtp.gmail.com", 587) as server:
            server.starttls()  # Upgrade the connection to secure
            server.login(sender_email, password)
            server.sendmail(sender_email, receiver_email, message.as_string())
        ic("Email sent successfully!")

        return "email sent"
       
    except Exception as ex:
        ic(ex)
        raise Exception("cannot send email", 500)
    finally:
        pass


##############################
def get_avatar_url(user_avatar_path):
    """Returns the correct URL for an avatar path, handling URLs, uploaded files, and legacy images."""
    # Handle None, empty string, or whitespace-only strings
    if not user_avatar_path or user_avatar_path.strip() == '':
        return url_for('static', filename='images/avatar_2.jpg')
    

    
    # If it's an uploaded file, use the uploads path
    if user_avatar_path.startswith('uploads/avatars/'):
        return url_for('static', filename=user_avatar_path)
    
    # Otherwise, assume it's a legacy image in the images folder
    return url_for('static', filename=f'images/{user_avatar_path}')
