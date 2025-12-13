# ----- Imports
from flask import Flask, render_template, request, redirect, url_for, session
# from passlib.context import CryptContext
import db as db
import static.python.getdata as get

# ----- Variables globales
conn = db.connect()
# password_ctx = CryptContext(schemes=['bcrypt'])
app = Flask(__name__)
app.secret_key = 'temp'

# ----- Application Flask
@app.route('/')
def accueil():
    return render_template("accueil.html", medias=get.all_media(), UserConnecte = session['active']['nom'] if 'active' in session else None ,favs = get.favs(session['active']['pseudo']) if 'active' in session else [])

@app.route('/media/<int:media_id>')
def detail_media(media_id):
    for media in get.infos_media(media_id):
        return render_template("media.html", media=media, comms = get.commMedia(media_id), artiste = get.artisteMedia(media_id), UserConnecte = session['active']['nom'] if 'active' in session else None ,favs = get.favs(session['active']['pseudo']) if 'active' in session else [])

@app.route('/rechercher')
def chercher():
    return render_template("rechercher.html", UserConnecte = session['active']['nom'] if 'active' in session else None)

@app.route("/login")
def login():
    return render_template("login.html", UserConnecte = session['active']['nom'] if 'active' in session else None)

@app.route("/deconnexion")
def deconnexion():
    session.pop('active', None)
    return redirect(url_for('accueil'))

@app.route("/profil", methods = ['POST', 'GET'])
def profil():
    if 'active' in session: #si on est déjà connecté afficher le profil..?
        return render_template("profil.html", info = session['active'], favs = get.favs(session['active']['pseudo']), comms = get.commUser(session['active']['pseudo']), stats = [], UserConnecte = session['active']['nom'] if 'active' in session else None)
    else:
        if request.method == 'POST':
            user_input, pass2 = request.form.get('user', type=str), request.form.get('password', type=str)
            for u in get.info_user(user_input):
                session['active']=u
                app.secret_key = session['active']['mdp']
            if pass2 == app.secret_key:
                return render_template("profil.html", info = session['active'], favs = get.favs(session['active']['pseudo']), comms = get.commUser(session['active']['pseudo']), stats = [], UserConnecte = session['active']['nom'] if 'active' in session else None)
            else:
                app.secret_key= None
                return redirect(url_for('login'))
        else:
            return redirect(url_for('login'))
            
    # hash_pw = "mdp crypté stocké!"
    # password_ctx.verify("inputmdp", hash_pw)

@app.route("/modifprofil")
def modifprofil():
    return render_template("modifprofil.html", info = session['active'], UserConnecte = session['active']['nom'] if 'active' in session else None)

@app.route('/modifprofilDone', methods=['POST'])
def modifprofilDone():
    pseudo = session['active']['pseudo']
    newName, newBio = request.form.get('nom', type=str), request.form.get('biographie', type=str)
    if newName == '':
        newName = session['active']['nom']
    if newBio == '':
        newBio = session['active']['biographie']
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("""update utilisateur
                set nom = %s,
                biographie = %s
                where pseudo = %s""", (newName, newBio, pseudo,))

    for u in get.info_user(pseudo):
        session['active']=u
        
    return redirect(url_for('profil'))


@app.route('/creationcompte')
def creationcompte():
    return render_template("creationcompte.html", note = '', UserConnecte = session['active']['nom'] if 'active' in session else None)

@app.route('/comptecree', methods=['POST'])
def comptecree():
    nom, mail, pseudo, pass1, pass2 = request.form.get('nom', type=str), request.form.get('email', type=str), request.form.get('username', type=str), request.form.get('password', type=str), request.form.get('passwordConfirm', type=str) 
    if pass1 != pass2:
        return render_template("creationcompte.html", note = "Les mots de passes ne conrrespondent pas. Veuillez Réessayer.", UserConnecte = session['active']['nom'] if 'active' in session else None) #redirect(url_for('creation_compte'))
    
    # hash = password_ctx.hash(pass1)
    with conn.cursor() as cur:
        cur.execute("""insert into utilisateur (pseudo, nom, mail, mdp, typeDeCompte)
                    values (%s, %s, %s, %s, 'standard') """, (pseudo, nom, mail, pass1,))
    return render_template('comptecree.html', UserConnecte = session['active']['nom'] if 'active' in session else None)

@app.route("/ajouterEnFavori/<int:mediaId>")
def ajouterEnFavori(mediaId):
    if 'active' in session:
        for favori in get.favs(session['active']['pseudo']):
            if mediaId in favori:
                req, vals= """update commente
                set favori = TRUE
                where utilisateur = %s, id_media = %s""", (session['active']['pseudo'], mediaId,)
            else:
                req, vals = """insert into commente (date, note, utilisateur, id_media, favori) VALUES
                    (CURRENT_DATE, 5, %s, %s, TRUE)""", (session['active']['pseudo'], mediaId, )
    
        with conn.cursor() as cur:
            cur.execute(req, vals)
        return redirect(url_for(detail_media(mediaId)))
    else:
        return redirect(url_for('login'))

@app.route("/commenter/<int:mediaId>", methods=['GET', 'POST'])
def commenter(mediaId): #BUGUE TOUJUOURS UN PEU, DONT TOUCH IG???
    if request.method == 'GET':
        return render_template("commenter.html", media = get.infos_media(mediaId)[0], UserConnecte = session['active']['nom'] if 'active' in session else None)
    else:
        comm, note = request.form.get("comm"), request.form.get("note")
        if comm == '':
            comm = None
        if type(note) != int:
            note = int(note)
        if 'active' in session:
            for favori in get.favs(session['active']['pseudo']):
                if mediaId in favori:
                    req, vals= """update commente
                    set note = %s, texte = %s
                    where utilisateur = %s, id_media = %s""", (note, comm, session['active']['pseudo'], mediaId,)
                else:
                    req, vals = """insert into commente (date, texte, note, utilisateur, id_media)
                        values (CURRENT_DATE, %s, %s, %s, %s)""", (comm, note, session['active']['pseudo'], mediaId,)
            with conn.cursor() as cur:
                cur.execute(req, vals)
            return redirect(url_for(detail_media(mediaId)))
        else:
            return redirect(url_for('login'))

@app.route("/commu")
def commu():
    return render_template("commu.html", comms = get.genComms() ,UserConnecte = session['active']['nom'] if 'active' in session else None)

@app.route("/ajoutMedia")
def ajoutMedia():
    return render_template("ajoutMedia.html", UserConnecte = session['active']['nom'] if 'active' in session else None)

@app.route("/ajoutArtiste")
def ajoutArtiste():
    return render_template("ajoutArtiste.html", UserConnecte = session['active']['nom'] if 'active' in session else None)
                           
@app.route("/genres")
def genres():
    return render_template("genre.html")
    
@app.route("/genres/<genre_name>")
def genre_detail(genre_name):
    medias = get.medias_by_genre(genre_name)
    return render_template("genre_detail.html", genre=genre_name, medias=medias, UserConnecte = session['active']['nom'] if 'active' in session else None)

    
@app.route("/artistes")
def artistes():
    return render_template("artistes.html", UserConnecte = session['active']['nom'] if 'active' in session else None)


if __name__ == '__main__':
    app.run(debug=True)
