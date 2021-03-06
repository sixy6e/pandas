#!/bin/bash

echo "[script_single]"

source activate pandas

# don't run the tests for the doc build
if [ x"$DOC_BUILD" != x"" ]; then
    exit 0
fi

if [ -n "$LOCALE_OVERRIDE" ]; then
    export LC_ALL="$LOCALE_OVERRIDE";
    echo "Setting LC_ALL to $LOCALE_OVERRIDE"

    pycmd='import pandas; print("pandas detected console encoding: %s" % pandas.get_option("display.encoding"))'
    python -c "$pycmd"
fi

if [ "$BUILD_TEST" ]; then
    echo "We are not running pytest as this is simply a build test."
elif [ "$COVERAGE" ]; then
    echo pytest -s -m "single" --cov=pandas --cov-report xml:/tmp/cov-single.xml --junitxml=/tmp/single.xml $TEST_ARGS pandas
    pytest -s -m "single" --cov=pandas --cov-report xml:/tmp/cov-single.xml --junitxml=/tmp/single.xml $TEST_ARGS pandas
else
    echo pytest -m "single" --junitxml=/tmp/single.xml $TEST_ARGS pandas
    pytest -m "single" --junitxml=/tmp/single.xml $TEST_ARGS pandas # TODO: doctest
fi

RET="$?"

exit "$RET"
