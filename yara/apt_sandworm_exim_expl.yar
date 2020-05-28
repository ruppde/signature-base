
rule APT_Sandworm_Keywords_May20_1 {
   meta:
      description = "Detects commands used by Sandworm group to exploit critical vulernability CVE-2019-10149 in Exim"
      author = "Florian Roth"
      reference = "https://media.defense.gov/2020/May/28/2002306626/-1/-1/0/CSA%20Sandworm%20Actors%20Exploiting%20Vulnerability%20in%20Exim%20Transfer%20Agent%2020200528.pdf"
      date = "2020-05-28"
   strings:
      $x1 = "MAIL FROM:<$(run("
      $x2 = "exec\\x20\\x2Fusr\\x2Fbin\\x2Fwget\\x20\\x2DO\\x20\\x2D\\x20http"
   condition:
      filesize < 8000KB and
      1 of them
}

rule APT_Sandworm_Keywords_May20_1 {
   meta:
      description = "Detects commands used by Sandworm group to exploit critical vulernability CVE-2019-10149 in Exim"
      author = "Florian Roth"
      reference = "https://media.defense.gov/2020/May/28/2002306626/-1/-1/0/CSA%20Sandworm%20Actors%20Exploiting%20Vulnerability%20in%20Exim%20Transfer%20Agent%2020200528.pdf"
      date = "2020-05-28"
   strings:
      $x1 = "MAIL FROM:<$(run("
      $x2 = "exec\\x20\\x2Fusr\\x2Fbin\\x2Fwget\\x20\\x2DO\\x20\\x2D\\x20http"
   condition:
      filesize < 8000KB and
      1 of them
}

rule APT_Sandworm_SSH_Key_May20_1 {
   meta:
      description = "Detects SSH key used by Sandworm on exploited machines"
      author = "Florian Roth"
      reference = "https://media.defense.gov/2020/May/28/2002306626/-1/-1/0/CSA%20Sandworm%20Actors%20Exploiting%20Vulnerability%20in%20Exim%20Transfer%20Agent%2020200528.pdf"
      date = "2020-05-28"
   strings:
      $x1 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2q/NGN/brzNfJiIp2zswtL33tr74pIAjMeWtXN1p5Hqp5fTp058U1EN4NmgmjX0KzNjjV"
   condition:
      filesize < 1000KB and
      $x1
}

rule APT_Sandworm_SSHD_Config_Modification_May20_1 {
   meta:
      description = "Detects ssh config entry inserted by Sandworm on compromised machines"
      author = "Florian Roth"
      reference = "https://media.defense.gov/2020/May/28/2002306626/-1/-1/0/CSA%20Sandworm%20Actors%20Exploiting%20Vulnerability%20in%20Exim%20Transfer%20Agent%2020200528.pdf"
      date = "2020-05-28"
   strings:     
      $x1 = "AllowUsers mysql_db" ascii

      $a1 = "ListenAddress" ascii fullword
   condition:
      filesize < 10KB and
      all of them
}

rule APT_Sandworm_InitFile_May20_1 {
   meta:
      description = "Detects mysql init script used by Sandworm on compromised machines"
      author = "Florian Roth"
      reference = "https://media.defense.gov/2020/May/28/2002306626/-1/-1/0/CSA%20Sandworm%20Actors%20Exploiting%20Vulnerability%20in%20Exim%20Transfer%20Agent%2020200528.pdf"
      date = "2020-05-28"
   strings:     
      $s1 = "GRANT ALL PRIVILEGES ON * . * TO 'mysqldb'@'localhost';" ascii
      $s2 = "CREATE USER 'mysqldb'@'localhost' IDENTIFIED BY '" ascii fullword
   condition:
      filesize < 10KB and
      all of them
}

rule APT_Sandworm_User_May20_1 {
   meta:
      description = "Detects user added by Sandworm on compromised machines"
      author = "Florian Roth"
      reference = "https://media.defense.gov/2020/May/28/2002306626/-1/-1/0/CSA%20Sandworm%20Actors%20Exploiting%20Vulnerability%20in%20Exim%20Transfer%20Agent%2020200528.pdf"
      date = "2020-05-28"
   strings:     
      $s1 = "mysql_db:x:" ascii /* malicious user */

      $a1 = "root:x:"
      $a2 = "daemon:x:"
   condition:
      filesize < 4KB and all of them
}

rule APT_WEBSHELL_PHP_Sandworm_May20_1 {
   meta:
      description = "Detects GIF header PHP webshell used by Sandworm on compromised machines"
      author = "Florian Roth"
      reference = "https://media.defense.gov/2020/May/28/2002306626/-1/-1/0/CSA%20Sandworm%20Actors%20Exploiting%20Vulnerability%20in%20Exim%20Transfer%20Agent%2020200528.pdf"
      date = "2020-05-28"
   strings:     
      $h1 = "GIF89a <?php $" ascii
      $s1 = "str_replace(" ascii
   condition:
      filesize < 10KB and
      $h1 at 0 and $s1
}

rule APT_SH_Sandworm_Shell_Script_May20_1 {
   meta:
      description = "Detects shell script used by Sandworm in attack against Exim mail server"
      author = "Florian Roth"
      reference = "https://media.defense.gov/2020/May/28/2002306626/-1/-1/0/CSA%20Sandworm%20Actors%20Exploiting%20Vulnerability%20in%20Exim%20Transfer%20Agent%2020200528.pdf"
      date = "2020-05-28"
   strings:     
      $x1 = "echo \"GRANT ALL PRIVILEGES ON * . * TO 'mysqldb'@'localhost';\" >> init-file.txt" ascii fullword
      $x2 = "import base64,sys;exec(base64.b64decode({2:str,3:lambda b:bytes(b,'UTF-8')}[sys.version" ascii fullword
      $x3 = "sed -i -e '/PasswordAuthentication/s/no/yes/g; /PermitRootLogin/s/no/yes/g;" ascii fullword
      $x4 = "useradd -M -l -g root -G root -b /root -u 0 -o mysql_db" ascii fullword
      
      $s1 = "/ip.php?port=${PORT}\"" ascii fullword
      $s2 = "sed -i -e '/PasswordAuthentication" ascii fullword
      $s3 = "PATH_KEY=/root/.ssh/authorized_keys" ascii fullword
      $s4 = "CREATE USER" ascii fullword
      $s5 = "crontab -l | { cat; echo" ascii fullword
      $s6 = "mysqld --user=mysql --init-file=/etc/opt/init-file.txt --console" ascii fullword
      $s7 = "sshkey.php" ascii fullword
   condition:
      uint16(0) == 0x2123 and
      filesize < 20KB and
      1 of ($x*) or 4 of them
}