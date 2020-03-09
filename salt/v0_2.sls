include:
  - docker-py

Create spiderman group:
  group.present:
    - name: spiderman
    - system: True

Create spiderman user:
  user.present:
    - name: spiderman
    - system: True
    - createhome: False
    - shell: /sbin/nologin
    - groups:
      - spiderman

Create spiderman data area:
  file.directory:
    - name: /run/spiderman-0.2
    - user: spiderman
    - group: spiderman
    - mode: '0755'

Create spiderman data content:
  file.managed:
    - names:
      - /run/spiderman-0.2/index.html:
        - source: salt://spiderman/index.html
      - /run/spiderman-0.2/spiderman.png:
        - source: salt://spiderman/spiderman-0.2.png

Copy spiderman docker tar ball:
  file.managed:
    - name: /tmp/alpine-nginx_latest.tar.xz
    - source: salt://spiderman/alpine-nginx_latest.tar.xz

Add spiderman docker image:
  cmd.run:
    - name: docker inspect alpine-nginx:latest > /dev/null 2>&1 || xzcat /tmp/alpine-nginx_latest.tar.xz | docker load

Remove spiderman docker tar ball:
  file.absent:
    - name: /tmp/alpine-nginx_latest.tar.xz

Stop previous spiderman docker:
  docker_container.absent:
    - name: spiderman
    - force: True

Run spiderman docker:
  docker_container.running:
    - name: spiderman
    - image: alpine-nginx:latest
    - command: nginx -g "daemon off;"
    - port_bindings:
      - 8080:80
    - binds:
      - /run/spiderman-0.2:/var/lib/nginx/html:ro,Z
    - auto_remove: True
