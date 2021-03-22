# ETA-calculador-vacunas-col
Un calculador del _Estimated Time of Accomplishment_ (Tiempo Estimado de Terminación) de la vacunación en Colombia.

El cálculo de ETA (inicialmente "Tiempo Estimado de Arrivo", posteriormente extendido a "Tiempo Estimado de Terminación") es algo que experimentamos todos los días: Lo vemos cuando descargamos un archivo grande de internet y el navegador nos informa aproximadamene cuántos minutos faltan para completar la descarga, cuando nuestro computador se actualiza, cuando la empresa de mensajería nos infoma la fecha probable de entrega de un paquete o cuando consultamos la hora probable de aterrizaje de un vuelo.

Los ETA están allí para informar, y en mi caso particular (es la razón para iniciar este repositorio) están allí para ayudarme a entender el futuro y a prepararme para él.

Hay modelos muy complejos para calcular un ETA. Hay aplicaciones que hacen uso de inteligencia artificial y otras herramientas relativamente complejas, pero también hay aplicaciones que hacen uso de herramientas muy simples, como ésta.

Los ETA no están libres de problemas o errores **y ciertamente no son un dato 100% confiable**. La palabra clave es **ESTIMADO**. Cuando su navegador le dice que quedan 23:11 para terminar la descarga, rara vez quedan 23:11. Normalmente queda un poco más o un poco menos, pero saber que faltan **aproximadamente** 23 minutos, le da a usted la libertad de pararse por un café, en lugar de quedarse mirando la pantalla por 23 minutos más.

Todos los ETA tienen un problema: Tratan de _estimar_ un futuro que es dependiente de un montón de variables, que interactúan de formas que son prácticamente imposibles de modelar. Este método de calcular el ETA de la vacunación en Colombia tiene exactamente el mismo problema y uno más: el modelo que estamos usando es bastante simple.

En esencia, estamos usando el promedio móvil de 7 días de dosis aplicadas _como si el ritmo de vacunación se fuera a mantener constante_ durante el tiempo que falta para vacunar a los 35 millones de personas que (esperamos) nos darán inmunidad de rebaño. En realidad el ritmo de vacunación **no se mantendrá constante**, porque depende de un número significativo de variables: disponibilidad del biológico, logística de distribución, capacidad instalada de los sistemas de vacunación y --el peor, creo yo-- la misma disposición de la gente a ser vacunada.

Así que **por favor use este cálculo con prudencia**. No es suficientemente bueno para tomar decisiones radicales, úselo como lo que es: **un ESTIMADO**.

## Método de Cálculo

$$
ETA = \frac{D_f}{\bar{v}} = \frac{(35\times10^6 \times 2) - D_J - D_r}{\bar{v}}
$$

Donde

+ $D_f$ son las dosis que faltan por aplicar,
+ $\bar{v}$ es el promedio móvil de 7 días de dosis aplicadas,
+ $D_J$ son las dosis recibidas de la vacuna de Janssen (dado que no requieren dos dosis si no una sola), y
+ $D_r$ son las dosis que han sido aplicadas (reales).

Los $35\times10^6$ (35 millones) son el número de personas que el Gobierno Nacional ha considerado que deben ser vacunadas para que, como País, alcancemos la inmunidad de rebaño.

### Una Observación Importante Sobre el Método de Cálculo

A la fecha (2021-03-22) la proyección de días que faltan para terminar la inmunización está por encima de 1000. **Proyectar un promedio de 7 días para 1000 días hacia el futuro está sujeto a una gran incertidumbre**, por lo que en la gráfica se adjunta el pronóstico de las dosis diarias con los rangos de confianza de 80% y 95%. La incertidumbre aumenta con el número de periodos que queremos mirar hacia el futuro, una mirada a esa gráfica puede indicar qué tan errado puede estar el pronóstico y por lo tanto el ETA.

## Código

El código fue escrito para R, utilizando varios paquetes, principalmente `data.table`, `ggplot2`, `forecast` y `lubridate`.

## Motivaciones Políticas

Contrario a lo que muchos señalan en Twitter, **no tengo ninguna motivación política con la estimación del ETA**. Lo hice porque a mi me tranquiliza tener una idea, aunque sea aproximada, de cuando algo va a acabar. Lo compartí en Twitter (y aquí) bajo la premisa que hay otras personas que, como yo, valoran más un estimado con un alto porcentaje de error, que _ningún estimado con 100% de certeza_.

Si usted considera que:

+ Yo tengo motivaciones políticas (o pertenezco a X o Y grupo político),
+ Soy un idiota, retrasado y no tengo derecho a decir lo que pienso,
+ Hago parte del nuevo orden ______ (mundial, departamental, municipal, etc), o
+ Presentar un ETA es un "despropósito", 

**le ruego el favor de que no lo consulte**.

Si por el contrario, usted considera que puede aportar (¡controvertir es una forma de aportar!), sus comentarios y discusiones serán totalmente bienvenidas.
