#!/bin/bash
STATUS=$1
STAGE=$2
MESSAGE=$3
COMMIT_ID=$(git -C ~/advanced-cicd rev-parse --short HEAD 2>/dev/null || echo "v1.0.0")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "================ NOTIFICATION DISPATCH ================"
echo "Time:      $TIMESTAMP"
echo "Status:    $STATUS"
echo "Stage:     $STAGE"
echo "Commit:    $COMMIT_ID"
echo "Details:   $MESSAGE"
echo "======================================================="
