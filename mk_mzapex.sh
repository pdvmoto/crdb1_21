
docker run -d  --hostname o23apex \
  --name o23apex \
  -p 1521:1521   \
  -p 8500:5500 -p 8023:8080 -p 9043:8443 -p 9922:22 \
  manzoorup/apex:latest


# then find :
# open http://localhost:8023/ords
# original pwd: internal / admin / manZOOR_1975
# I changed to Oracle26a!
§
