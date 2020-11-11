# Custom drone build of drone

- Build with tags "nolimit"
- Image contains all 3 binaries: agent, controlle, server
- No default entrypoint
- No default enviroment variables, because they could not be overriden with --env-file parameters (probably a bug in drone)
- default listening port is 8080 for the drone server
