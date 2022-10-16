select nombre as "nombre de gimnasios"
from gym;

select concat(usuario,clase) as codigoReservas
from reserva
where clase in (select codigo_clase from clases where (month(fecha) = 1 and year(fecha)=2021));

select * 
from usuario 
where edad > 30;

select nombre,sum(cobra) as cobrado
from monitor_clases 
inner join monitor on monitor_clases.codigo_monitor = monitor.codigo_monitor 
where codigo_clase in(select codigo_clase from clases where(year(fecha)=2022)) group by monitor_clases.codigo_monitor;

select concat(u.nombre," ",u.apellidos) as "usuarios en zumba"
from clases as c
inner join clase_tipo as ct on c.id_tipo=ct.clase_tipo
inner join reserva as r on r.clase=c.codigo_clase
inner join usuario as u on u.codigo_u = r.usuario
where ct.nombre="zumba";

select ct.nombre,count(u.nombre) as"usuarios apuntados"
from clases as c
inner join clase_tipo as ct on c.id_tipo=ct.clase_tipo
inner join reserva as r on r.clase=c.codigo_clase
inner join usuario as u on u.codigo_u = r.usuario
group by ct.clase_tipo
order by ct.nombre;

select g.nombre as "nombre gimnasio" ,count(cl.codigo_clase) as "numero de clases ofertadas"
from gym as g
inner join salas as s on s.id_gym = g.codigo_gym
inner join clases as cl on cl.id_sala = s.codigo_salas
group by g.nombre;

select g.nombre as "gimnasio", concat(m.nombre," ",m.apellidos) as "monitor", count(mc.codigo_monitor) as "numero de clases"
from gym as g
inner join salas as s on s.id_gym = g.codigo_gym
inner join clases as c on c.id_sala = s.codigo_salas
inner join monitor_clases mc on mc.codigo_clase = c.codigo_clase
inner join monitor as m on m.codigo_monitor = mc.codigo_monitor
group by concat(m.codigo_monitor, g.nombre)
order by count(mc.codigo_monitor) desc;

select concat(g.nombre,"-",s.nombre,"-",ct.nombre,"-",m.nombre) as "gimnasio-sala-tiopo de clase-monitor"
from gym as g
inner join salas as s on s.id_gym = g.codigo_gym
inner join clases as c on c.id_sala = s.codigo_salas
inner join clase_tipo as ct on ct.clase_tipo = c.id_tipo
inner join monitor_clases mc on mc.codigo_clase = c.codigo_clase
inner join monitor as m on m.codigo_monitor = mc.codigo_monitor
order by g.nombre;

select monitor.nombre as monitor, clase_tipo.descripcion as "clases con más de 4 usuarios", monitor_clases.cobra
from monitor
inner join monitor_clases on monitor_clases.codigo_monitor=monitor.codigo_monitor
inner join clases on clases.codigo_clase=monitor_clases.codigo_clase
inner join clase_tipo on clase_tipo.clase_tipo=clases.id_tipo
inner join reserva on reserva.clase=clases.codigo_clase
inner join usuario on usuario.codigo_u=reserva.usuario
group by reserva.clase
having count(reserva.clase)>3;

select concat(u.nombre," ", u.apellidos) as "usuarios que no han ido a clases", u.dni
from usuario as u
left join reserva as r on (r.usuario = u.codigo_u)
where r.usuario is null;

select concat(c.id_sala," ",ct.nombre)as "sala y clases a las que no ha asistido nadie"
from clases as c
left join reserva as r on (r.clase = c.codigo_clase)
left join clase_tipo as ct on (ct.clase_tipo = c.id_tipo)
where r.usuario is null;

select usuario.codigo_u as "código de usuario", usuario.nombre as "nombre usuario", gym.nombre as gymnasio, sum(reserva.precio) as "pago últimos 90 días"
from usuario
inner join reserva on reserva.usuario=usuario.codigo_u
inner join clases on clases.codigo_clase=reserva.clase
inner join salas on salas.codigo_salas= clases.id_sala
inner join gym on gym.codigo_gym=salas.id_gym
where fecha between date_add(now(), interval -90 day) and now()
group by usuario.dni, gym.nombre;

select clase_tipo.nombre as "nombre de clase", monitor.nombre as monitor, monitor_clases.cobra
from clase_tipo
inner join clases on clases.id_tipo=clase_tipo.clase_tipo
inner join monitor_clases on monitor_clases.codigo_clase=clases.codigo_clase
inner join monitor on monitor.codigo_monitor=monitor_clases.codigo_monitor
order by clase_tipo.nombre;

select reserva.clase, sum(reserva.precio) as "importe generado", gym.nombre as gimnasio
from reserva
inner join clases on clases.codigo_clase= reserva.clase
inner join salas on salas.codigo_salas= clases.id_sala
inner join gym on gym.codigo_gym=salas.id_gym
group by reserva.clase
order by sum(reserva.precio) desc;

select count(reserva.usuario) as "cantidad de usuarios que han reservado",clases.codigo_clase, clases.fecha, clase_tipo.nombre as actividad, concat(monitor.nombre," ", monitor.apellidos) as monitor
from reserva
inner join clases on clases.codigo_clase=reserva.clase
inner join clase_tipo on clase_tipo.clase_tipo=clases.id_tipo
inner join monitor_clases on monitor_clases.codigo_clase=clases.codigo_clase
inner join monitor on monitor.codigo_monitor=monitor_clases.codigo_monitor
where clases.fecha between '2022-02-01' and '2022-02-15'
group by clases.codigo_clase;

select count(reserva.usuario)as "cantidad de alumnos",clases.codigo_clase, clase_tipo.nombre
from reserva
inner join clases on clases.codigo_clase=reserva.clase
inner join clase_tipo on clase_tipo.clase_tipo=clases.id_tipo
group by reserva.clase
having (count(reserva.usuario)>2);

select usuario.codigo_u as "código de usuario", usuario.nombre as"nombre de usuario", gym.nombre as gimnasio, reserva.precio as pagado, clase_tipo.nombre as actividad
from usuario
inner join reserva on reserva.usuario=usuario.codigo_u
inner join clases on clases.codigo_clase=reserva.clase
inner join clase_tipo on clase_tipo.clase_tipo= clases.id_tipo
inner join salas on salas.codigo_salas=clases.id_sala
inner join gym on gym.codigo_gym=salas.id_gym
group by concat(reserva.usuario, reserva.clase);

