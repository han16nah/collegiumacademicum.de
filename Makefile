BASEDIR=$(CURDIR)
CONTENTDIR=$(BASEDIR)/content
STATICDIR=$(BASEDIR)/static
OUTPUTDIR=$(BASEDIR)/public
OUTPUTDIR_UPLOAD=$(BASEDIR)/upload
SASSDIR=$(BASEDIR)/sass

LOCALURL=http://localhost/~morris/ca/public/

FTP_HOST=collegiumacademicum.de
FTP_USER=anonymous
FTP_TARGET_DIR=/

help:
	@echo 'Makefile for a hugo Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make css                            (re)generate the stylesheets       '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make local_html                     (re)gen the web site for local dev '
	@echo '   make clean                          remove the generated files         '
	@echo '   make publish                        generate using production settings '
	@echo '   make local_publish                  generate using local settings '
	@echo '   make ftp_upload                     upload the web site via FTP        '
	@echo '                                                                          '


css:
	sass $(SASSDIR)/main.sass $(STATICDIR)/main.css

html:
	hugo -d $(OUTPUTDIR_UPLOAD)

local_html:
	hugo -D --i18n-warnings -b $(LOCALURL) -d $(OUTPUTDIR)

local_clean:
	hugo --gc; [ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

clean:
	hugo --gc; [ ! -d $(OUTPUTDIR_UPLOAD) ] || rm -rf $(OUTPUTDIR_UPLOAD)

publish: css html
local_publish: css local_html

ftp_upload: publish
	lftp ftp://$(FTP_USER)@$(FTP_HOST) -e "mirror -R $(OUTPUTDIR) $(FTP_TARGET_DIR) ; quit"

.PHONY: html help clean publish ftp_upload
