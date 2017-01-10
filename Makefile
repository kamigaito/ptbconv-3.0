PACKAGEDIR = /home/hiroya-y/www/software/ptbconv-3.0/..

all : chmod check

chmod:
	chmod 755 /home/hiroya-y/www/software/ptbconv-3.0/ptbconv ;

html:
	rd2 /home/hiroya-y/www/software/ptbconv-3.0/readme.rd > /home/hiroya-y/www/software/ptbconv-3.0/readme.html ; 

check:
	/home/hiroya-y/www/software/ptbconv-3.0/ptbconv -V < /home/hiroya-y/www/software/ptbconv-3.0/sample ;
	/home/hiroya-y/www/software/ptbconv-3.0/ptbconv -VD < /home/hiroya-y/www/software/ptbconv-3.0/sample ;
	/home/hiroya-y/www/software/ptbconv-3.0/ptbconv -HTVD < /home/hiroya-y/www/software/ptbconv-3.0/sample ;

clean:
	rm -f /home/hiroya-y/www/software/ptbconv-3.0/ptbconv ;
	rm -f /home/hiroya-y/www/software/ptbconv-3.0/readme.rd ; 
