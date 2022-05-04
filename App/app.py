from flask import Flask
from textwrap import dedent
app = Flask(__name__)

@app.route("/")
def AppResponse():
    return dedent(f"""
        "version": "1.0.0",
        "build_sha": "AppSHAValue",
        "description" : "pre-interview technical test"
        """
    )

if __name__ == "__main__":
    app.run(host='0.0.0.0')