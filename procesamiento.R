# Este código es utilizado para calcular el ETA de la vacunación en Colombia
# El método que utiliza es bastante simple, así que la incertidumbre del dato
# es consecuentemente bastante grande.
#         ÚSELO CON PRECAUCIÓN
#       NO ES LA VERDAD REVELADA

# ----------------------------------------------------------------------------

# Carga de librerías
library(data.table) # procesamiento de datos
library(lubridate) # manejo de fechas
library(ggplot2) # gráficas
library(patchwork) # unión de gráficas en una sola hoja
library(forecast) # cálculo del pronóstico con intervalos de confianza

# carga de datos (los datos se digitan manualmente)
datos <- fread("files/datos.csv")

# Los datos sólo tienen dosis acumuladas, así que es necesario calcular las 
# nuevas dosis aplicadas
datos[, nuevasDosis := dosisAcumuladas - shift(dosisAcumuladas, 1)]

# Se calcula el promedio móvil de 7 días de dosis aplicadas _para cada día_
datos[, prom := frollmean(nuevasDosis, 7)]

# El acumulado de Janssen, para restarlo del total de dosis
datos[, acumuladoJanssen := cumsum(janssen)]

# Se deben vacunar 35 millones de personas. La mayoría de las vacunas son de dos
# dosis (35 x 2 = 70 millones), pero las de Janssen son de una sola dosis.
datos[, faltante := 70e6 - acumuladoJanssen - dosisAcumuladas]

# este es el "working horse": los días que faltan si se mantiene el promedio 
# de 7 días
datos[, diasFaltan := faltante / prom]

# La fecha proyectada entonces no es más que sumar la fecha a los días que 
# faltan. Es necesario redondear para que pueda sumar las fechas, y se suma 1
# porque siempre empieza desde "mañana"
datos[, fechaP := as.Date(fecha) + days(1 + round(diasFaltan, 0))]

# Estas son para hacer el código más corto:
fechaFin <- datos[.N, fechaP] # la última fecha final
coordenadax <- Sys.Date() - days(10) # una coordenada para poner el texto
coordenaday <- datos[, max(diasFaltan, na.rm = TRUE)*.8]

# El gráfico que muestra los días que faltan en función de la fecha
p1 <- ggplot(datos, aes(fecha, diasFaltan))+
  geom_point(color = "seagreen")+
  geom_line(color = "darkgreen")+
  geom_label(aes(x = coordenadax, y = coordenaday, label = "Si seguimos al ritmo promedio\nde los últimos 7 días,\nterminamos en"), size = 4)+
  geom_label(aes(x = coordenadax, y = 0.75*coordenaday, label = fechaFin), size = 6, color = "red")+
  labs(y = "Días para completar 70 millones de dosis")+
  scale_y_continuous(labels = scales::comma)

# Estas son para hacer el código más corto
promU7 <- datos[.N, prom] # último promedio
dosisU <- datos[.N, dosisAcumuladas] # últimas dosis acumuladas
dosisF <- 70e6 - dosisU # último dato de dosis faltantes.

# El gráfico que muestra el avance de las vacunas diarias (barra) y el promedio
# móvil de 7
p2 <- ggplot(datos, aes(x = fecha))+
  geom_col(aes(y = nuevasDosis), fill = "seagreen")+
  geom_line(aes(y = prom), color = "darkgreen", size = 2)+
  scale_y_continuous(labels = scales::comma, name = "Nuevas Dosis Aplicadas y promedio 7 días")+
  geom_label(aes(x = ymd("2021-02-27"), y = 100e3, label = paste0("Promedio últimos 7 días: ", scales::comma(promU7, .1), " dosis/día")))+
  geom_label(aes(x = ymd("2021-02-27"), y = 85e3, label = paste0("Dosis aplicadas: ", scales::comma(dosisU, 1), " dosis")))+
  geom_label(aes(x = ymd("2021-02-27"), y = 70e3, label = paste0("Dosis por aplicar: ", scales::comma(dosisF, 1), " dosis")))

# El gráfico que muestra la incerdidumbre del pronóstico con los datos hasta
# la fecha
p3 <- autoplot(forecast(datos$nuevasDosis, 10))+
  labs(title = "Pronóstico de dosis diarias, horizonte 10 días", 
       x = "Días desde el inicio", 
       y = "Dosis / día",
       subtitle = "Áreas azules representan intervalos de confianza 80 y 95%")+
  scale_y_continuous(labels = scales::comma)
                 


# ---------------------------------------------------------------------------
# definir un nombre archivo para guardar la gráfica. Tiene la fecha del día
filename = paste0("output/plot_", Sys.Date(), ".jpeg")

# y el código para salvar la gráfica. Se usa patchwork para poner las gráficas
# de días faltante y promedio arriba y la de incertidumbre abajo
ggsave((p1 + p2 ) / p3, filename = filename, device = "jpeg", height = 8.5, width = 11, units = "in")

# Esto es una ayudita para poner el texto en Twitter
cat(paste0("Fecha proyectada para finalizar inmunización de 35 millones de personas: ", as.character(fechaFin), ".\nEs un _ESTIMADO_, úselo con precaución y entienda que está sujeto a un error significativo.\n"))

