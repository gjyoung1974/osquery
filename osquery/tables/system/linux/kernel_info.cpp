/**
 *  Copyright (c) 2014-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed in accordance with the terms specified in
 *  the LICENSE file found in the root directory of this source tree.
 */

#include <osquery/core.h>
#include <osquery/filesystem/filesystem.h>
#include <osquery/logger.h>
#include <osquery/tables.h>
#include <osquery/utils/conversions/split.h>

namespace osquery {
namespace tables {

static const std::string kKernelArgumentsPath = "/host/proc/cmdline";
static const std::string kKernelSignaturePath = "/host/proc/version";

QueryData genKernelInfo(QueryContext& context) {
  QueryData results;
  Row r;

  if (pathExists(kKernelArgumentsPath).ok()) {
    std::string arguments_line;
    // Grab the whole arguments string from proc.
    if (readFile(kKernelArgumentsPath, arguments_line).ok()) {
      auto arguments = split(arguments_line, " ");
      std::string additional_arguments;

      // Iterate over each space-tokenized argument.
      for (const auto& argument : arguments) {
        if (argument.substr(0, 11) == "BOOT_IMAGE=") {
          r["path"] = argument.substr(11);
        } else if (argument.substr(0, 5) == "root=") {
          r["device"] = argument.substr(5);
        } else {
          if (additional_arguments.size() > 0) {
            additional_arguments += " ";
          }
          additional_arguments += argument;
        }
      }
      r["arguments"] = additional_arguments;
    }
  } else {
    TLOG << "Cannot find kernel arguments file: " << kKernelArgumentsPath;
  }

  if (pathExists(kKernelSignaturePath).ok()) {
    std::string signature;

    // The signature includes the kernel version, build data, buildhost,
    // GCC version used, and possibly build date.
    if (readFile(kKernelSignaturePath, signature).ok()) {
      auto details = split(signature, " ");
      if (details.size() > 2 && details[1] == "version") {
        r["version"] = details[2];
      }
    }
  } else {
    TLOG << "Cannot find kernel signature file: " << kKernelSignaturePath;
  }

  results.push_back(r);
  return results;
}
}
}
