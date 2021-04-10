# Fitxer
input=$1

# Nom del fitxer
filename="${1%.*}"

current=$PWD

# Inserta el path adecuat
osm_importer="C:\\Users\\fguas\\AppData\\Local\\Programs\\Webots\\resources\\osm_importer\\"

sumo_exporter="C:\\Users\\fguas\\AppData\\Local\\Programs\\Webots\\resources\\sumo_exporter\\"

sumo_netconvert="C:\\Users\\fguas\\AppData\\Local\\Programs\\Webots\\projects\\default\\resources\\sumo\\bin\\"

[ ! -e "${filename}.wbt" ] || rm "${filename}.wbt" 
[ ! -e "${filename}_net" ] || rm -R "${filename}_net" 

mkdir -p "${filename}_net"

echo $input
cd $osm_importer
echo "Creant el fitxer wbt"
python36 importer.py --input="${current}\\${input}"  --output="${current}\\${filename}.wbt"

echo "Creant fitxer network SUMO"
cd $sumo_exporter
python36 exporter.py --input="${current}\\${filename}.wbt" --output="${current}\\${filename}_net"

echo "Creating SUMO network"
cd $sumo_netconvert
./netconvert.exe  --node-files="${current}\\${filename}_net\\sumo.nod.xml" --edge-files="${current}\\${filename}_net\\sumo.edg.xml" --output-file="${current}\\${filename}_net\\sumo.net.xml" 


echo "Creating SUMO Route File Randomly"
cd ../tools
python36  randomTrips.py -n "${current}\\${filename}_net\\sumo.net.xml" -o "${current}\\${filename}_net\\sumo.trip.xml"



## Delete bad formate line 
sed -i "5s/.*/<routes>/"  "${current}\\${filename}_net\\sumo.trip.xml"

##
cd ../bin
./duarouter --trip-files "${current}\\${filename}_net\\sumo.trip.xml" --net-file "${current}\\${filename}_net\\sumo.net.xml" --output-file "${current}\\${filename}_net\\sumo.rou.xml" --ignore-errors true


echo "Done"
