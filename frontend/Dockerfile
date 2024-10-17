# Utiliser l'image Node.js officielle
FROM node:22 AS build-stage

# Créer et définir le répertoire de travail
WORKDIR /app

COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier les fichiers de ton projet
COPY . .

# Renommer le fichier .env.prod en .env
RUN mv .env.prod .env

# Compiler l'application Vue.js
RUN npm run build

# Étape 2 : Serveur Nginx pour la prod
FROM nginx:alpine

# Copier les fichiers de build dans le répertoire Nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Renommer le fichier de configuration Nginx par défaut
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.disabled

# Copier le fichier de configuration Nginx personnalisé
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]