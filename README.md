# scp-pfsense
Backup pfsense

Para añadir los equipos a realizar backup editar la siguiente variable:
```
/usr/local/sbin/bck-pfsense.sh
LIST_FIREWALLS="x.x.x.x y.y.y.y"
```
A nivel de pfsense el usuario bck tiene que tener permisos de SCP y la key ssh copiada.
