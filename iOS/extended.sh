#!/bin/sh

WORKSPACE=[INSERT PATH TO WORKSPACE]
SCHEME=[INSERT TARGET TO BUILD AND TEST]
CONFIGURATION=Debug
TEST_REPORT="$(pwd)/test_reports/${SCHEME}.xml"
CODE_COVERAGE_REPORT="$(pwd)/code_coverage/${SCHEME}.xml"

function main()
{
	setup
	
	test_code
	
	ci_status=$?
	
	capture_code_coverage
	
	return ci_status
}

function setup()
{
	bundle install --path=.bundle --binstubs=bin
	
	bin/pod install
}

function test_code()
{
  xctool test \
		-workspace ${WORKSPACE} \
		-scheme ${SCHEME} \
		-configuration ${CONFIGURATION} \
		-reporter plain \
		-reporter junit:"${TEST_REPORT}" \
		-sdk iphonesimulator \
		PROJECT_TEMP_DIR=$(mktemp -d -t $(SCHEME)) \
		ONLY_ACTIVE_ARCH=NO
			
	return $?
}

function capture_code_coverage()
{
  mkdir "${code_coverage_dir}"
  gcovr -f '[INSERT/REMOVE OPTIONAL FILTER]' -x \
        -o "${CODE_COVERAGE_REPORT}"
}

main $@