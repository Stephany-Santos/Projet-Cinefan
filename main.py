from flask import Flask, render_template, request, redirect, url_for, session


app = Flask(__name__)

# Ouverture directe sur l'accueil
@app.route('/')
def index():
    return render_template('accueil.html')


@app.route("/accueil")
def accueil():
    return render_template("accueil.html")




if __name__ == '__main__':
    app.run()