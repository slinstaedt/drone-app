# Custom drone build of drone

- Build with tags "nolimit"
- Image contains all 3 binaries: agent, controlle, server
- No default entrypoint
- No default enviroment variables, because they clash with --env-file parameters
