# Étape de build: utilisation d'une image Node.js Alpine légère
FROM node:20.11.0-alpine AS build

# Définir le répertoire de travail
WORKDIR /app

# Copier uniquement les fichiers nécessaires pour installer les dépendances
# Cela permet d'optimiser le cache Docker
COPY package.json package-lock.json ./

# Installer les dépendances avec npm ci (plus rapide et reproductible)
RUN npm ci

# Copier le reste du code source
COPY . .

# Construire l'application en mode production
RUN npm run build

# Étape d'exécution: utilisation d'une image Nginx Alpine légère
FROM nginx:1.27-alpine

# Copier la configuration Nginx personnalisée
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copier les fichiers de build depuis l'étape précédente vers le répertoire /app
# (comme indiqué dans le README.md, la configuration Nginx suppose que les fichiers
# statiques compilés sont accessibles dans le répertoire /app)
COPY --from=build /app/dist/olympic-games-starter /app

# Exposer le port 80
EXPOSE 80

# Nginx démarre automatiquement quand le conteneur est lancé