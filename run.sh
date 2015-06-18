# このディレクトリに移動
cd `dirname $0`

# Delete all containers
docker rm $(docker ps -a -q)
# Delete all images
docker rmi $(docker images -q)

# ビルド
docker build --no-cache --rm -t elasticsearch-img:0.1.0 .

# 前回起動中のものがあれば削除
docker stop elasticsearch
docker rm elasticsearch

# リンクして実行
docker run -d -p 9200:9200 --name elasticsearch --link mysql:mysql elasticsearch-img:0.1.0

sleep 10

./add.sh
