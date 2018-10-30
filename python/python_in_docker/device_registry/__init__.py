import markdown
import os

# Import the framework
from flask import Flask

# Create an instance of flask
app = Flask(__name__)

@app.route("/")
def index():
    """Display the README.md"""

    # Open the readme file
    with open(os.path.dirname(app.root_path) + '/README.md', 'r') as markdown_file:

        # Read the content of the file
        content = markdown_file.read()

        # Conver to HTML
        return markdown.markdown(content)