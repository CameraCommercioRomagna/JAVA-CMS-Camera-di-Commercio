# JAVA-CMS-Camera-di-Commercio
CMS per sito istituzionale Camera di Commercio

<h2>Descrizione</h2>
<p>
<img src="https://user-images.githubusercontent.com/83453314/116717307-0b72c380-a9d9-11eb-978b-b1e1a5760437.png">

Strumento software realizzato al fine di facilitare la gestione dei contenuti di siti web delle Camere di Commercio, svincolando gli utenti che inseriscono i contenuti da conoscenze tecniche specifiche di programmazione Web.
Il CMS è stato realizzato in conformità alle Linee Guida di design per i servizi web della PA. Il sistema aiuta i redattori nella creazione di pagine web strutturate e nella promozione dei contenuti di rilievo sulla home page del sito. 
Il CMS è anche corredato di servizi che consentono agli utenti di prenotare appuntamenti, o di chiedere informazioni specifiche per il Registro imprese in apposite form.
Dall'area riservata per gli utenti redattori è inoltre possibile generare codice Html appositamente formattato per la generazione di mailing promozionali.
</p>
<h2>Stato del progetto</h2>
<p>Il prodotto è stabile ed è usato dalla Camera di Commercio della Romagna. Lo sviluppo di nuove funzionalità viene fatto su richiesta del committente.</p>
<h2>Prerequisiti di sistema</h2>
Di seguito vengono indicati i requisiti di sistema su cui è installato e configurato il portale web.
<h3>INSTALLAZIONE SERVER WEB:</h3>
<h4>
  Sistema operativo:
</h4>
<ul><li>Red Hat Enterprise Linux Server release 7.4</li></ul>
<h4>Server web:</h4>
<ul>
  <li>Apache Http Server version 2.4.6</li>
  <li>Apache Tomcat Version 9.0.17</li>
  <li>Apache Tomcat Connectors 1.2.46 (module mod_jk)</li></ul>
<p>INSTALLAZIONE APACHE:<br/>
    yum -y install httpd<br/>
    yum -y install mod_ssl openssl<br/>
    systemctl enable httpd</p>
 <p>
  INSTALLAZIONE TOMCAT:<br/>
  wget http://it.apache.contactlab.it/tomcat/tomcat-9/v9.0.17/bin/apache-tomcat-9.0.17.tar.gz<br/>
  tar -xzvf apache-tomcat-9.0.17.tar.gz
  </p>
  <p>
    INSTALLAZIONE CONNETTORE:<br/>
yum install httpd-devel apr apr-devel apr-util apr-util-devel gcc gcc-c++ make autoconf libtool<br/>
wget http://it.apache.contactlab.it/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.46-src.tar.gz<br/>
tar -xvzf tomcat-connectors-1.2.46-src.tar.gz<br/>
./configure --with-apxs=/usr/bin/apxs --enable-api-compatibility<br/>
make<br/>
libtool --finish /usr/lib64/httpd/modules<br/>
make install

  </p>
    
 <h4>Java:</h4>
 <ul><li> OpenJDK 1.8.0</li></ul>
 <p>
  INSTALLAZIONE JAVA:<br/>
yum -y install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64
</p>
  <h4>Motore di Ricerca:</h4>
  <ul>
    <li>Apache Nutch 1.15</li>
    <li>Apache Solr 7.5.0</li>
  </ul>
  <p>
  INSTALLAZIONE MOTORE DI RICERCA:<br/>
wget solr-7.5.0.tgz<br/>
tar xzf solr-7.5.0.tgz solr-7.5.0/bin/install_solr_service.sh --strip-components=2<br/>
bash ./install_solr_service.sh solr-7.5.0.tgz -i /opt/search<br/>
wget apache-nutch-1.15-bin.tar.gz<br/>
tar xzf apache-nutch-1.15-bin.tar.gz 
</p>
<h3>INSTALLAZIONE DMBS:</h3>
<ul><li>PostgreSQL 11.2</li></ul>
<h2>Copyright</h2>
<p>Titolare del software è la <a href="https://www.romagna.camcom.it">Camera di Commercio della Romagna Forlì-Cesena Rimini</a></p>
<h2>Mantainer</h2>
<p>Il progetto è stato interamente realizzato da <a href="https://www.ciseonweb.it">CISE Centro per l'innovazione e lo sviluppo economico</a>, azienda speciale della Camera di Commercio di Forlì-Cesena Rimini</p>

<p>Per segnalazioni di sicurezza scrivere a <a href="mailto:security@ciseonweb.it">security@ciseonweb.it</a></p>

