# Copyright (c) 2014-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed in accordance with the terms specified in
# the LICENSE file found in the root directory of this source tree.

function(osqueryWorkerMain)
    add_subdirectory("ipc")
    add_subdirectory("logging")
endfunction()

osqueryWorkerMain()
