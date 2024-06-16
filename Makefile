NAME=goss
BINDIR=bin
GOBUILD=CGO_ENABLED=0 go build -ldflags '-w -s -buildid='
# The -w and -s flags reduce binary sizes by excluding unnecessary symbols and debug info
# The -buildid= flag makes builds reproducible

all: linux macos-amd64 macos-arm64 win64 win32

linux:
	GOARCH=amd64 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(NAME)-$@

macos-amd64:
	GOARCH=amd64 GOOS=darwin $(GOBUILD) -o $(BINDIR)/$(NAME)-$@

macos-arm64:
	GOARCH=arm64 GOOS=darwin $(GOBUILD) -o $(BINDIR)/$(NAME)-$@

win64:
	GOARCH=amd64 GOOS=windows $(GOBUILD) -o $(BINDIR)/$(NAME)-$@.exe

win32:
	GOARCH=386 GOOS=windows $(GOBUILD) -o $(BINDIR)/$(NAME)-$@.exe


test: test-linux test-macos-amd64 test-macos-arm64 test-win64 test-win32

test-linux:
	GOARCH=amd64 GOOS=linux go test

test-macos-amd64:
	GOARCH=amd64 GOOS=darwin go test

test-macos-arm64:
	GOARCH=arm64 GOOS=darwin go test

test-win64:
	GOARCH=amd64 GOOS=windows go test

test-win32:
	GOARCH=386 GOOS=windows go test

releases: linux macos-amd64 macos-arm64 win64 win32
	chmod +x $(BINDIR)/$(NAME)-*
	tar czf $(BINDIR)/$(NAME)-linux.tar -C $(BINDIR) $(NAME)-linux
	tar czf $(BINDIR)/$(NAME)-macos-intel.tar -C $(BINDIR) $(NAME)-macos-amd64
	tar czf $(BINDIR)/$(NAME)-macos-apple_silicon.tar -C $(BINDIR) $(NAME)-macos-arm64
	zip -m -j $(BINDIR)/$(NAME)-win32.zip $(BINDIR)/$(NAME)-win32.exe
	zip -m -j $(BINDIR)/$(NAME)-win64.zip $(BINDIR)/$(NAME)-win64.exe



clean:
	rm $(BINDIR)/*


upload: releases
	$(eval GH_RELEASE_UPLOAD_URL := $(shell echo "$(GH_RELEASE_UPLOAD_URL)" | sed 's/{?name,label}//'))
	@echo "Modified GH_RELEASE_UPLOAD_URL: $(GH_RELEASE_UPLOAD_URL)"
	@echo "Uploading assets..."
	@curl -H "Authorization: token $(GH_TOKEN)" \
		-F "name=$(NAME)-linux.tar" \
		-F "file=@$(BINDIR)/$(NAME)-linux.tar" \
		"$(GH_RELEASE_UPLOAD_URL)?name=$(NAME)-linux.tar"
	@curl -H "Authorization: token $(GH_TOKEN)" \
		-F "name=$(NAME)-macos-amd64.tar" \
		-F "file=@$(BINDIR)/$(NAME)-macos-amd64.tar" \
		"$(GH_RELEASE_UPLOAD_URL)?name=$(NAME)-macos-amd64.tar"
	@curl -H "Authorization: token $(GH_TOKEN)" \
		-F "name=$(NAME)-macos-arm64.tar" \
		-F "file=@$(BINDIR)/$(NAME)-macos-arm64.tar" \
		"$(GH_RELEASE_UPLOAD_URL)?name=$(NAME)-macos-arm64.tar"
	@curl -H "Authorization: token $(GH_TOKEN)" \
		-F "name=$(NAME)-win64.zip" \
		-F "file=@$(BINDIR)/$(NAME)-win64.zip" \
		"$(GH_RELEASE_UPLOAD_URL)?name=$(NAME)-win64.zip"
	@curl -H "Authorization: token $(GH_TOKEN)" \
		-F "name=$(NAME)-win32.zip" \
		-F "file=@$(BINDIR)/$(NAME)-win32.zip" \
		"$(GH_RELEASE_UPLOAD_URL)?name=$(NAME)-win32.zip"





