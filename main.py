# ----- Imports
from flask import Flask, render_template, request, redirect, url_for, session
# from passlib.context import CryptContext
import db as db
import static.python.getdata as get

# ----- Variables globales
conn = db.connect()
# password_ctx = CryptContext(schemes=['bcrypt'])
app = Flask(__name__)
current_user = {'pseudo': '', 'nom': '', 'bio': '', 'mdp': ''}

# ----- Application Flask
@app.route('/')
def accueil():
    return render_template("accueil.html", medias=get.all_media())

@app.route('/media/<int:media_id>')
def detail_media(media_id):
    for media in get.infos_media(media_id):
        return render_template("media.html", media=media)

@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/profil", methods = ['POST'])
def profil():
    # global current_user
    user, pass2 = request.form.get('user', type=str), request.form.get('password', type=str)
    for current_user in get.user(user):
        return render_template("profil.html", info = current_user, favs = get.favs(user), comms = get.comms(user), stats = {})
    # if current_user['pseudo'] != '': #si on est déjà connecté afficher le profil..?
    #     return render_template("profil.html", info = current_user, favs = get.favs(user), comms = get.comms(user), stats = {})#get.favs(current_user['pseudo']))
    # else:
    #     user, pass2 = request.form.get('user', type=str), request.form.get('password', type=str)
    #     for u in get.user(user):
    #         current_user = u
    #     print(current_user)
    #     if current_user['mdp'] == pass2:
    #         return render_template("profil.html", info = current_user, favs = get.favs(user), comms = get.comms(user), stats = {})
    #     else:
    #         return url_for('login')
            
    # hash_pw = "mdp crypté stocké!"
    # password_ctx.verify("inputmdp", hash_pw)

@app.route("/modifprofil")
def modifprofil():
    return render_template("modifprofil.html", info = current_user)

@app.route("/modifprofil/<user>", methods=['POST'])
def modifprofilend():
    global current_user
    newName, newBio = request.form.get('nom', type=str), request.form.get('biographie', type=str)
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("""update utilisateur
                set nom = %s,
                biographie = %s
                where pseudo = %s""", (newName, newBio,current_user['pseudo'],))

    current_user['bio'], current_user['nom']= newBio, newName
        
    return render_template("profil.html", info = current_user, favs = {}, comms = {}, stats = {})


@app.route("/creationcompte")
def creationcompte():
    return render_template("creationcompte.html", note = '')

@app.route('/comptecree', methods=['POST'])
def comptecree():
    nom, mail, user, pass1, pass2 = request.form.get('nom', type=str), request.form.get('email', type=str), request.form.get('username', type=str), request.form.get('password', type=str), request.form.get('passwordConfirm', type=str) 
    if pass1 != pass2:
        return render_template("creationcompte.html", note = "Les mots de passes ne conrrespondent pas. Veuillez Réessayer.") #redirect(url_for('creation_compte'))
    
    # hash = password_ctx.hash(pass1)
    with conn.cursor() as cur:
        cur.execute("""insert into utilisateur (pseudo, nom, mail, mdp, typeDeCompte)
                    values (%s, %s, %s, %s, 'standard') """, (user, nom, mail, pass1,))
        print("User inserted ! try connecting now.")
    return render_template('comptecree.html')

@app.route("/genres")
def genres():
    return render_template("genres.html")
    
@app.route("/artistes")
def artistes():
    return render_template("artistes.html")


if __name__ == '__main__':
    app.run(debug=True)
