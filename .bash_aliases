# scans for js files with https://github.com/ffuf/ffuf on a list of urls in a file
# usage: scanjs file.txt
# output: urls found with 200 http responses
scanjs(){
	now=$(date +"%Y%m%d%H%M%S")
	echo "Scanjs started $now. Log file: scanjs_$now.txt" | tee -a scanjs_$now.txt
	cat $1 | while read line; do 
		FILENAME=$line
		FUZZ="FUZZ"
		EXT=".js"
		echo "Scanning...$FILENAME$FUZZ$EXT" | tee -a scanjs_$now.txt
		echo "Wordlist 1.txt..." | tee -a scanjs_$now.txt
		SECONDS=0
		ffuf -u "$FILENAME$FUZZ$EXT" -s -c -mc "200" -w ~/tools/__diccionarios/1.txt | tee -a scanjs_$now.txt
		echo "Finished in $SECONDS seconds" | tee -a scanjs_$now.txt
		echo "Wordlist 2.txt..." | tee -a scanjs_$now.txt
		SECONDS=0
		ffuf -u "$FILENAME$FUZZ$EXT" -s -c -mc "200" -w ~/tools/__diccionarios/2.txt | tee -a scanjs_$now.txt
		echo "Finished in $SECONDS seconds" | tee -a scanjs_$now.txt
		echo "Wordlist 3.txt..." | tee -a scanjs_$now.txt
		SECONDS=0
		ffuf -u "$FILENAME$FUZZ$EXT" -s -c -mc "200" -w ~/tools/__diccionarios/3.txt | tee -a scanjs_$now.txt
		echo "Finished in $SECONDS seconds" | tee -a scanjs_$now.txt
		echo "Wordlist 4.txt..." | tee -a scanjs_$now.txt
		SECONDS=0
		ffuf -u "$FILENAME$FUZZ$EXT" -s -c -mc "200" -w ~/tools/__diccionarios/4.txt | tee -a scanjs_$now.txt
		echo "Finished in $SECONDS seconds" | tee -a scanjs_$now.txt
		echo "Wordlist 5.txt..." | tee -a scanjs_$now.txt
		SECONDS=0
		ffuf -u "$FILENAME$FUZZ$EXT" -s -c -mc "200" -w ~/tools/__diccionarios/5.txt | tee -a scanjs_$now.txt
		echo "Finished in $SECONDS seconds" | tee -a scanjs_$now.txt
	done
}

# scans for subdomains files with https://github.com/ffuf/ffuf on a list of urls in a file
# usage: scansub file.txt
# output: urls found with XXX http responses
# TODO
scansub(){
	now=$(date +"%Y%m%d%H%M%S")
	http="http://"
	https="https://"
	#echo "Scansub started $now. Log file: scansub_$now.txt" | tee -a scansub_$now.txt
	cat $1 | while read line; do 
		foo=${line/$http/}
		foo=${line/$https/}
		length=$(curl -s -H \"Host: nonexistent.$foo\" $line |wc -c)
		echo "a $length"		
		#echo "Scanning...$line" | tee -a scansub_$now.txt
		#echo "Wordlist 1.txt..." | tee -a scansub_$now.txt
		#SECONDS=0
		#ffuf -u "$line" -s -c -w ~/tools/__diccionarios/1y4.txt | tee -a scansub_$now.txt
		#echo "Finished in $SECONDS seconds" | tee -a scansub_$now.txt
		#echo "Wordlist 2.txt..." | tee -a scansub_$now.txt
		#SECONDS=0
		#ffuf -u "$line" -s -c -w ~/tools/__diccionarios/2y3.txt | tee -a scansub_$now.txt
		#echo "Finished in $SECONDS seconds" | tee -a scansub_$now.txt
	done
}

# creates a new file with unique and ordered lines from source file 
# usage: uniquelines file.txt
# output: fileunique.txt
uniquelines(){
	FILENAME=$1
	sort -u $1 > "${FILENAME%%.*}unique.${FILENAME#*.}"
	echo "Duplicated lines deleted. File created: ${FILENAME%%.*}unique.${FILENAME#*.}"
}

# creates a new file with email accounts found in source file
# usage: grepemails file.txt
# output: fileemails.txt
grepemails(){
	FILENAME=$1
	grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" $1 > "${FILENAME%%.*}emails.txt"
	echo "File created: ${FILENAME%%.*}emails.txt"
}

linkfinder(){
	cd ~/tools/LinkFinder*
	python3 linkfinder.py -i $1 -d
}

ipinfo(){
	curl http://ipinfo.io/$1
}

check(){
	assetfinder $1 | httprobe
}
# reloads aliases in current terminal without the need to close and start a new
reload(){
	source ~/.bash_aliases
	echo ".bash_aliases reloaded"
}
# updates OS?
update(){
	sudo apt update && sudo apt upgrade -y
	sudo apt dist-upgrade
	pip install --upgrade pip
	pip-review --interactive
	sudo apt autoremove
	sudo apt-get clean
	sudo apt-get autoclean
}

#------ Tools ------
dirsearch(){
cd ~/tools/dirsearch*
python3 dirsearch.py -x 301,302 -f -u $1 -e json,js,html,htm,bck,tmp,_js,_tmp,asp,aspx,php,php3,php4,php5,txt,shtm,shtml,phtm,phtml,jhtml,pl,jsp,cfm,cfml,py,rb,cfg,zip,pdf,gz,tar,tar.gz,tgz,doc,docx,xls,xlsx,conf
}

dirsearchjs(){
cd ~/tools/dirsearch*
python3 dirsearch.py -x 301,302 -f -u $1 -e js,_js,js2
}
dirsearchjs2(){
cd ~/tools/dirsearch*
python3 dirsearch.py -x 301,302 -f -u $1 -e js -w db/1.txt
python3 dirsearch.py -x 301,302 -f -u $1 -e js -w db/2.txt
python3 dirsearch.py -x 301,302 -f -u $1 -e js -w db/3.txt
python3 dirsearch.py -x 301,302 -f -u $1 -e js -w db/4.txt
python3 dirsearch.py -x 301,302 -f -u $1 -e js -w db/5.txt
}

sqlmap(){
cd ~/tools/sqlmap*
python3 sqlmap.py -u $1 --level=5 --risk=3 --threads=10 --dump --tor --tamper=apostrophemask,apostrophenullencode,appendnullbyte,base64encode,between,bluecoat,chardoubleencode,charencode,charunicodeencode,concat2concatws,equaltolike,greatest,halfversionedmorekeywords,ifnull2ifisnull,modsecurityversioned,modsecurityzeroversioned,multiplespaces,percentage,randomcase,randomcomments,space2comment,space2dash,space2hash,space2morehash,space2mssqlblank,space2mssqlhash,space2mysqlblank,space2mysqldash,space2plus,space2randomblank,sp_password,unionalltounion,unmagicquotes,versionedkeywords,versionedmorekeywords
}

netcat(){
nc -lvnp 3333
}

# recon hackerone 25/09/2019 ekoparty
recon(){
curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1 > ~/recon/$1.txt
cd ~/tools/dirsearch
cat ~/recon/$1.txt | while read line; do httprobe $line > ~/recon/$1_httprobe.txt; done | 
cat ~/recon/$1_httprobe.txt | while read line; do python3 dirsearch.py -f -u $1 -e json,js,html 
#,htm,bck,tmp,_js,_tmp,asp,aspx,php,php3,php4,php5,txt,shtm,shtml,phtm,phtml,jhtml,pl,jsp,cfm,cfml,py,rb,cfg,zip,pdf,gz,tar,tar.gz,tgz,doc,docx,xls,xlsx,conf;
done

}
#para instalar todas las aplicaciones que utilizo
install(){
cd ~
mkdir tools
cd tools
sudo apt update
sudo apt upgrade
sudo apt dist-upgrade
sudo apt-get -y install python3-pip
pip install pip-review
sudo apt-get install golang-go
git clone https://github.com/maurosoria/dirsearch.git
git clone https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
git clone https://github.com/GerbenJavado/LinkFinder.git
go get -u github.com/tomnomnom/httprobe
go get -u github.com/tomnomnom/assetfinder
go get -u github.com/ffuf/ffuf
sudo apt autoremove
sudo apt-get clean
sudo apt-get autoclean
pip install --upgrade pip
pip-review --local --interactive
}

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH