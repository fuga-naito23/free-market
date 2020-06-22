echo "docker pull ruby;2.7.0"
docker pull ruby:2.7.0

echo "docker pull mysql:8.0"
docker pull mysql:8.0

echo "docker images"
docker images

echo "make Dockefile"

echo "make docker-compose.yml"


echo "Compose-Up WebContainer and DBContainer."
echo "docker-compose up -d"
docker-compose up -d

echo "Create a new project."
echo "docker-compose run web rails new $1 --datebase=mysql"
docker-compose run web rails new project --datebase=mysql

echo "Rewrite ./config/database.yml for connection of MySQL container"
sed -i -e 's/password:$/password: password/g' $1/config/database.yml
sed -i -e 's/host: localhost$/host: db/g' $1/config/database.yml

echo "Create a Database."
echo "rails db:crate"
docker-compose run web rails db:create --workdir="/usr/src/$1"

echo "Start rails server."
echo "docker-compose run web rails server"
docker-compose run web rails server --workdir="/usr/src/$1"