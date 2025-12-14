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

@app.route('/search')
def search():
    terme = request.args.get('q', '').strip()
    resultats = get.search_all(terme)
    return render_template("resultats_recherche.html", terme=terme, resultats=resultats, nb_resultats=len(resultats),
                           UserConnecte = session['active']['nom'] if 'active' in session else None)

@app.route("/media/<int:id_media>/personnages")
def personnages(id_media):
    pass

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
        return render_template("profil.html", info = session['active'], favs = get.favs(session['active']['pseudo']), comms = get.commUser(session['active']['pseudo']), stats = [], activite = get.activityUser(session['active']['pseudo']), UserConnecte = session['active']['nom'] if 'active' in session else None)
    else:
        if request.method == 'POST':
            user_input, pass2 = request.form.get('user', type=str), request.form.get('password', type=str)
            for u in get.info_user(user_input):
                session['active']=u
                app.secret_key = session['active']['mdp']
            if pass2 == app.secret_key:
                return render_template("profil.html", info = session['active'], favs = get.favs(session['active']['pseudo']), comms = get.commUser(session['active']['pseudo']), stats = [], activite = get.activityUser(session['active']['pseudo']), UserConnecte = session['active']['nom'] if 'active' in session else None)
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
        return redirect(url_for('detail_media', media_id=mediaId))
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
            return redirect(url_for('detail_media', media_id=mediaId))
        else:
            return redirect(url_for('login'))

@app.route("/commu")
def commu():
    return render_template("commu.html", comms = get.genComms(), ajout = get.derniersAjouts(),UserConnecte = session['active']['nom'] if 'active' in session else None)

@app.route("/ajoutMedia", methods=['GET', 'POST'])
def ajoutMedia():
    if request.method == 'GET':
        return render_template("ajoutMedia.html",
                               medias = get.all_media(),
                               artiste=get.artiste(),
                               genre = get.genre(),
                               typeMedia = get.typeMedia(),
                               UserConnecte = session['active']['nom'] if 'active' in session else None)
    else:
        titre = request.form.get('titre')
        desc = request.form.get('desc')
        date = request.form.get('date')
        type_media = request.form.get('type')
        genre = request.form.get('genre')
        realise = request.form.get('realise')
        suite = request.form.get('suite')
        
        if suite == '' or suite is None:
            suite = None
        req = """insert into media (titre, description, parution, type, genre, realise, suite, cree_par) 
        values (%s, %s, %s, %s, %s, %s, %s, %s)
        returning id_media"""
        vals = (titre, desc, date, type_media, genre, realise, suite, session['active']['pseudo'])
        with conn.cursor() as cur:
            cur.execute(req, vals)
            idMedia = cur.fetchone()[0]
            cur.execute("""insert into partictipe (id_artiste, id_media, role)
                        values (%s, %s, %s)""", (realise, idMedia, 'Réalisateur'))
            if request.form.get('imgAjout') == 'True':
                lien, fichier, alt = request.form.get('lien'),request.form.get('fichier'),request.form.get('alt')
                imgReq, imgVals = """insert into image (fichier, lien, alt, media, cree_par)
                            values (%s,%s,%s, %s, %s )
                            """, (fichier, lien, alt, idMedia, session['active']['pseudo'],)
                cur.execute(imgReq, imgVals)
            conn.commit()
        return redirect( url_for('commu'))

@app.route("/ajoutArtiste", methods=['POST', 'GET'])
def ajoutArtiste():
    if request.method == 'GET':
        return render_template("ajoutArtiste.html",
                               roles = get.artisteRole(),
                               medias = get.all_media(),
                               UserConnecte = session['active']['nom'] if 'active' in session else None)
    else:
        nom = request.form.get("nom")
        prenom = request.form.get("prenom")
        participe = request.form.get("participe")
        role = request.form.get("role")
        if participe is None or participe == '':
            participe = None
        if role is None or role == '':
            role = None
        if nom is None or nom == '':
            nom = None
        req = """insert into artiste (nom, prenom, cree_par)
                values (%s, %s, %s)
                returning id_artiste"""
        vals  = (nom, prenom, session['active']['pseudo'],)
        with conn.cursor() as cur:
            cur.execute(req, vals)
            idArtiste = cur.fetchone()[0]
            if participe is not None or role is not None:
                cur.execute("""insert into participe (id_artiste, id_media, role)
                                values (%s, %s, %s)""", (idArtiste, participe, role,))
            if request.form.get('imgAjout') == 'True':
                lien, fichier, alt = request.form.get('lien'),request.form.get('fichier'),request.form.get('alt')
                imgReq, imgVals = """insert into image (fichier, lien, alt, artiste, cree_par)
                            values (%s,%s,%s, %s, %s )
                            """, (fichier, lien, alt, idArtiste, session['active']['pseudo'],)
                cur.execute(imgReq, imgVals)
            conn.commit()
@app.route("/ajoutIPerso", methods=['POST', 'GET'])
def ajoutPerso():    
    if request.method == 'GET':
        return render_template("ajoutPerso.html", UserConnecte = session['active']['nom'] if 'active' in session else None)
    else:
        pass
    
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
