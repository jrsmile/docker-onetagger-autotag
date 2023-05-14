# docker-onetagger-autotag
Dockercontainer that uses onetagger to enrich mp3 files in a folder

[https://hub.docker.com/r/jrsmile/onetagger-autotag]

run docker exec -it *splogin* command before first start to create spotify login token.
to remeber the token between container updates mount a volume to /root/.config/onetagger/
mount your music folder to /music

there are two modes of operation:
1. autotagging via inotify ( automagically updates all mp3s in /music as they arrive) [Default] no config necessary except spotify token.
2. by running the *autotag* command all files in the music folder will be scanned and updated.