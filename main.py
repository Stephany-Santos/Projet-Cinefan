from flask import Flask, render_template, request, redirect, url_for, session
# from passlib.context import CryptContext
import db as db
import static.python.getdata as get
import static.python.filtres as filtre

conn = db.connect()
conn.autocommit = True
# password_ctx = CryptContext(schemes=['bcrypt'])
app = Flask(__name__)
app.secret_key = 'temp'

def calcul_badge_activite(pseudo):
    nb_comms = len(get.commUser(pseudo))
    nb_favs = len(get.favs(pseudo))
    activite = get.activityUser(pseudo)
    nb_ajouts = sum(len(v) for v in activite.values()) if activite else 0

    total = nb_comms + nb_favs + nb_ajouts

    if total >= 50:
        return {"emoji": "🏆", "label": "Meilleur contributeur"}
    elif total >= 25:
        return {"emoji": "🔥", "label": "Très actif"}
    elif total >= 10:
        return {"emoji": "✨", "label": "Actif"}
    elif total >= 1:
        return {"emoji": "🌱", "label": "Peu actif"}
    else:
        return {"emoji": "💤", "label": "Pas très actif"}
        

@app.route('/')

def accueil():
    return render_template("accueil.html", medias=get.all_media(), UserConnecte = session['active']['nom'] if 'active' in session else None,
                           favs = get.favs(session['active']['pseudo']) if 'active' in session else [])

@app.route('/media/<int:media_id>')
def detail_media(media_id):
    for media in get.infos_media(media_id):
        return render_template(
            "media.html", media=media, comms=get.commMedia(media_id), personnages=get.personnage_infos(media_id), realisateurs=get.realisateurs_media(media_id),
            UserConnecte=session['active']['nom'] if 'active' in session else None, favs=get.favs(session['active']['pseudo']) if 'active' in session else []
        )
    
@app.route('/artiste/<int:artiste_id>')
def detail_artiste(artiste_id):
    for artiste in get.infos_artiste(artiste_id):
        return render_template(
            "artiste_detail.html", artiste=artiste,
            UserConnecte=session['active']['nom'] if 'active' in session else None, favs=get.favs(session['active']['pseudo']) if 'active' in session else []
        )


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
        return render_template("profil.html",
                               info = session['active'],
                               favs = get.favs(session['active']['pseudo']),
                               comms = get.commUser(session['active']['pseudo']),
                               stats = filtre.critiques_per_user(session['active']['pseudo']),
                               activite = get.activityUser(session['active']['pseudo']),
                               UserConnecte = session['active']['nom'] if 'active' in session else None)
    else:
        if request.method == 'POST':
            user_input, pass2 = request.form.get('user', type=str), request.form.get('password', type=str)
            for u in get.info_user(user_input):
                session['active']=u
                app.secret_key = session['active']['mdp']
            if pass2 == app.secret_key:
                return render_template("profil.html",
                                       info = session['active'],
                                       favs = get.favs(session['active']['pseudo']),
                                       comms = get.commUser(session['active']['pseudo']),
                                       stats = filtre.critiques_per_user(session['active']['pseudo']),
                                       activite = get.activityUser(session['active']['pseudo']),
                                       UserConnecte = session['active']['nom'] if 'active' in session else None)
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
        req, vals = '', ''
        for favori in get.favs(session['active']['pseudo']):
            if mediaId in favori:
                req, vals= """update commente
                set favori = TRUE
                where utilisateur = %s, id_media = %s""", (session['active']['pseudo'], mediaId,)
        if req == '' and vals == '':
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
            req, vals = '', ''
            favs = get.favs(session['active']['pseudo'])[0]['media'][0]
            for favori in favs:
                if mediaId == favori['id']:
                    req, vals= """update commente
                    set note = %s, texte = %s
                    where utilisateur = %s, id_media = %s""", (note, comm, session['active']['pseudo'], mediaId,)
            if req == '' and vals == '':
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
                               genre = get.all_genres(),
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
        
        if request.form.get('imgAjout') == 'True':
            lien, fichier, alt = request.form.get('lien'),request.form.get('fichier'),request.form.get('alt')
            imgReq, imgVals = """insert into image (fichier, lien, alt, media, cree_par)
                        values (%s,%s,%s, %s, %s )
                        """, (fichier, lien, alt, idMedia, session['active']['pseudo'],)   
        
        with conn.cursor() as cur:
            cur.execute(req, vals)
            idMedia = cur.fetchone()[0]
            cur.execute("""insert into participe (id_artiste, id_media, role)
                        values (%s, %s, %s)""", (realise, idMedia, 'Réalisateur'))
            if request.form.get('imgAjout') == 'True':
                cur.execute(imgReq, imgVals)
                
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
        bio = request.form.get("desc")
        req = """insert into artiste (nom, prenom, biographie, cree_par)
                values (%s, %s, %s, %s)
                returning id_artiste"""
        vals  = (nom if nom != '' else None, prenom, bio if bio !='' else None,session['active']['pseudo'],)
        
        with conn.cursor() as cur:
            cur.execute(req, vals)
            idArtiste = cur.fetchone()[0]
            if request.form.get('imgAjout') == 'True':
                lien, fichier, alt = request.form.get('lien'),request.form.get('fichier'),request.form.get('alt')
                imgReq, imgVals = """insert into image (fichier, lien, alt, artiste, cree_par)
                            values (%s,%s,%s, %s, %s )
                            """, (fichier, lien, alt, idArtiste, session['active']['pseudo'],)
                cur.execute(imgReq, imgVals)
        return redirect( url_for('commu'))
             

@app.route("/ajoutPerso", methods=['POST', 'GET'])
def ajoutPerso():    
    if request.method == 'GET':
        return render_template("ajoutPerso.html",
                               artistes = get.artiste(),
                               medias = get.all_media(),
                               role = get.artisteRole(),
                               notice = '',
                               UserConnecte = session['active']['nom'] if 'active' in session else None)
    else:
        nom, prenom, bio = request.form.get('nom'), request.form.get('prenom'), request.form.get('desc')
        a, m, r = request.form.get('artiste'), request.form.get('media'), request.form.get('role')
        if a == '' and m == '' and r == '':
             return render_template("ajoutPerso.html",
                               artistes = get.artiste(),
                               medias = get.all_media(),
                               role = get.artisteRole(),
                               notice = 'Veuillez connecter votre personnage à au moins une page.',
                               UserConnecte = session['active']['nom'] if 'active' in session else None)
        else:
            req = """insert into personnage (nom, prenom, description, media, cree_par)
                    values (%s,%s,%s, %s, %s)
                    returning id_perso"""
            vals = (nom, prenom, bio,
                    m if m != '' else None,
                    session['active']['pseudo'],)
            
            with conn.cursor() as cur:
                cur.execute(req, vals)
                idPerso = cur.fetchone()[0]
                if request.form.get('imgAjout') == 'True':
                    lien, fichier, alt = request.form.get('lien'), request.form.get('fichier'),request.form.get('alt')
                    imgReq, imgVals = """insert into image (fichier, lien, alt, artiste, cree_par)
                                values (%s,%s,%s, %s, %s )
                                """, (fichier, lien, alt, idPerso, session['active']['pseudo'],)
                    cur.execute(imgReq, imgVals)
                cur.execute("""insert into participe (id_artiste, id_media, id_perso, role)
                                values (%s, %s, %s, %s)""", (a if a != '' else None, m if m != '' else None, idPerso, r if r != '' else None,))
                    
            return redirect(url_for('commu'))
@app.route("/ajoutImg", methods=['POST', 'GET'])
def ajoutImg():    
    if request.method == 'GET':
        return render_template("ajoutImg.html",
                               artistes = get.artiste(),
                               medias = get.all_media(),
                               persos = get.persos(),
                               notice = '',
                               UserConnecte = session['active']['nom'] if 'active' in session else None)
    else:
        lien, fichier, alt = request.form.get('lien'),request.form.get('fichier'),request.form.get('alt')
        a, m, p = request.form.get('artiste'), request.form.get('media'), request.form.get('perso')
        if a == '' and m == '' and p == '':
             return render_template("ajoutImg.html",
                               artistes = get.artiste(),
                               medias = get.all_media(),
                               persos = get.persos(),
                               notice = 'Veuillez connecter votre image à au moins une page.',
                               UserConnecte = session['active']['nom'] if 'active' in session else None)
        else:
            req = """insert into image (fichier, lien, alt, artiste, media, personnage, cree_par)
                    values (%s,%s,%s, %s, %s, %s, %s )
                    """
            vals = (fichier, lien, alt, a if a != '' else None, m if m != '' else None, p if p != '' else None, session['active']['pseudo'],)
            with conn.cursor() as cur:
                cur.execute(req, vals)
            return redirect(url_for('commu'))
            
    
@app.route("/genres")
def genres():
    categories = get.themes(5)
    top_consultes = get.top_genres(5)
    genres = get.all_genres()
    return render_template(
        "genre.html",
        categories=categories,
        top_consultes=top_consultes,
        genres=genres,
        UserConnecte=session['active']['nom'] if 'active' in session else None
    )
@app.route("/themes")
def themes_page():
    categories = get.themes(20)
    return render_template("themes.html", categories=categories, UserConnecte=session['active']['nom'] if 'active' in session else None)

@app.route("/top-consultes")
def top_consultes_page():
    top_consultes = get.top_genres(20)
    return render_template("top_consultes.html", top_consultes=top_consultes, UserConnecte=session['active']['nom'] if 'active' in session else None)

@app.route("/genres/all")
def genres_all():
    genres = get.all_genres()
    return render_template("genres_all.html", genres=genres, UserConnecte=session['active']['nom'] if 'active' in session else None)


@app.route("/artistes")
def artistes():
    return render_template("artistes.html", UserConnecte = session['active']['nom'] if 'active' in session else None)

@app.route("/stats")
def stats():
    return render_template("stats.html", UserConnecte=session['active']['nom'] if 'active' in session else None)

@app.route("/stats/mieux-notes")
def stats_mieux_notes():
    # récupère les médias les mieux notés
    resultats = get.mieux_notes()  # fonction à créer dans getdata.py
    return render_template("stats_mieux_notes.html", stats=resultats, sous_menu="mieux-notes",
                           UserConnecte=session['active']['nom'] if 'active' in session else None)

@app.route("/stats/plus-regardes")
def stats_plus_regardes():
    resultats = get.plus_regardes()
    return render_template("stats_plus_regardes.html", stats=resultats, sous_menu="plus-regardes",
                           UserConnecte=session['active']['nom'] if 'active' in session else None)

@app.route("/stats/coups-de-coeur")
def stats_coups_de_coeur():
    resultats = get.coups_de_coeur()
    return render_template("stats_coups_de_coeur.html", stats=resultats, sous_menu="coups-de-coeur",
                           UserConnecte=session['active']['nom'] if 'active' in session else None)

@app.route("/stats/etoiles-montantes")
def stats_etoiles_montantes():
    resultats = get.etoiles_montantes()
    return render_template("stats_etoiles_montantes.html", stats=resultats, sous_menu="etoiles-montantes",
                           UserConnecte=session['active']['nom'] if 'active' in session else None)


if __name__ == '__main__':
    app.run(debug=True)
