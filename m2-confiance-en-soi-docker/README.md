# m2-confiance-en-soi-docker

📦 Application Express (Node.js) à dockeriser !

## Comment démarrer le projet ?

- Cloner le projet sur son ordinateur
- Se placer sur le dossier
- `npm install`
- `node app.js` pour démarrer le serveur

Tu devrais avoir le message suivant sur ton terminal

```shell
> node app.js
Example app listening on port 8888
```

Tu peux alors ouvrir sur un navigateur (ou [Postman](https://www.postman.com/) / [HTTPie](https://httpie.io/) / [Bruno](https://www.usebruno.com/) selon ta préférence) et accéder aux deux URLs suivantes :

- http://localhost:8888/affirmation/en
- http://localhost:8888/affirmation/fr

## A faire

- Forker ce projet
- Dockeriser cette application Express en créant un `Dockerfile` (et ne plus la lancer en faisant un `node app.js` depuis son ordinateur mais en faisant un `docker run`)
- Remplacer la liste de citations codées en dur par une interaction avec une base de données (tu peux t'aider de [sequelize](https://sequelize.org/))
