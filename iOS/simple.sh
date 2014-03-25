#!/bin/sh

WORKSPACE=[INSERT PATH TO WORKSPACE]
SCHEME=[INSERT TARGET TO BUILD AND TEST]
CONFIGURATION=Debug

function main()
{
	setup
	
	test_code
	
	return $?
}

function setup()
{
	bundle install --path=.bundle --binstubs=bin
	
	bin/pod install
}

function test_code()
{
  xctool test \
		-workspace $WORKSPACE \
		-scheme $SCHEME \
		-configuration $CONFIGURATION \
		-reporter plain \
		-sdk iphonesimulator \
		PROJECT_TEMP_DIR=$(mktemp -d -t $(SCHEME)) \
		ONLY_ACTIVE_ARCH=NO
			
	return $?
}

main $@