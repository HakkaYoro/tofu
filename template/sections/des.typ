#import "../templates/defintions.typ": center, left, sections
#import "../templates/template.typ": section

#set math.equation(numbering: "(1)")

#section(
  sections.des,
)[
  == Sintaxis y Ejemplos de Typst para Trabajos de Investigación

  Esta sección funciona como una guía compacta y referencia práctica de la sintaxis de Typst necesaria para redactar trabajos de investigación universitarios, adaptada a los estándares académicos comunes (como las Normas APA 7.ª edición).

  === Encabezados y Estructura Jerárquica

  Para organizar el contenido de manera formal y evitar conflictos con el índice y la paginación de la plantilla, se deben emplear los siguientes niveles de encabezados:

  - *Secciones principales (Nivel 1):* Se gestionan automáticamente mediante el comando `#section(sections.des)[...]` en cada archivo. *No se deben usar encabezados manuales de nivel 1 (`= Título`)* dentro de las secciones.
  - *Subsecciones (Nivel 2):* Se definen con `== Título` al inicio de la línea.
  - *Sub-subsecciones (Nivel 3):* Se definen con `=== Título`.
  - *Divisiones adicionales:* Se declaran con `==== Título` (Nivel 4) y `===== Título` (Nivel 5) según se requiera.

  === Formato y Estilo de Texto

  El formato de texto en Typst es ágil y directo:

  - *Negrita:* Envuelve el texto con asteriscos, por ejemplo: `*texto en negrita*` resulta en *texto en negrita*.
  - *Cursiva (Énfasis):* Envuelve el texto con guiones bajos, por ejemplo: `_texto en cursiva_` resulta en _texto en cursiva_.
  - *Negrita y Cursiva:* Se puede combinar usando ambos símbolos: `_*texto combinado*_` resulta en _*texto combinado*_.
  - *Notas al pie:* Útiles para añadir aclaraciones marginales o comentarios del autor[^nota-aclaratoria]. Se insertan escribiendo `[^identificador]` en el flujo de texto y definiéndola al final del párrafo o sección con `[^identificador]: Contenido`.
  - *Citas textuales largas (en bloque):* De acuerdo con las normas de estilo, las citas textuales de más de 40 palabras deben presentarse en un bloque sangrado independiente. Esto se logra con la función `#quote`:
    #quote(block: true)[
      La composición tipográfica con herramientas de código abierto como Typst representa un cambio de paradigma en la edición académica, facilitando la separación definitiva entre el contenido redactado y la lógica de diseño del documento final.
    ]
  - *Enlaces web:* Se pueden insertar de forma directa escribiendo la URL, como `https://typst.app`, o con texto personalizado usando la función `#link`: #link("https://typst.app")[Portal Oficial de Typst].

  [^nota-aclaratoria]: Las notas al pie de página se numeran y posicionan de manera totalmente automática en la parte inferior de la página correspondiente.

  === Listas y Enumeraciones

  > [!IMPORTANT]
  > En la redacción académica no se debe abusar de las listas a menos que sea estrictamente necesario para la claridad del texto, ya que un exceso de estas puede afectar negativamente la fluidez del discurso.

  ==== Listas de viñetas (no ordenadas)
  Se inician con un guion `-` seguido de un espacio:
  - Primer concepto clave o elemento analizado.
  - Segundo concepto complementario.
    - Subconcepto indentado para desglosar detalles adicionales.

  ==== Listas numeradas (ordenadas)
  Se inician con el símbolo `+` seguido de un espacio:
  + Primera etapa correspondiente a la recolección de muestras de campo.
  + Segunda fase dedicada al análisis estadístico de los datos.

  === Fórmulas y Ecuaciones Matemáticas

  Typst incluye un motor matemático sumamente potente. Las expresiones matemáticas pueden escribirse en línea o en bloques independientes numerados.

  ==== Matemáticas en línea
  Se escriben rodeadas por un único símbolo de dólar `$`: la ecuación fundamental de la energía se expresa como $E = m c^2$ dentro del propio párrafo.

  ==== Bloques de ecuaciones numeradas
  Para destacar una ecuación en una línea independiente y poder referenciarla en el texto, se escribe rodeada de dólares `$ ... $` y se le asigna una etiqueta `<eq-relatividad>` justo después (habiéndose habilitado la numeración con `#set math.equation(numbering: "(1)")` en el documento):

  $ G_(mu nu) + Lambda g_(mu nu) = frac(8 pi G, c^4) T_(mu nu) $ <eq-relatividad>

  ==== Operadores y elementos comunes
  - *Fracciones:* Se utiliza la sintaxis `frac(numerador, denominador)` o directamente `a / b` dentro del bloque: $frac(d y, d x)$ o $x / y$.
  - *Sumatorias e Integrales:* $sum_(i=1)^n x_i$ y $integral_0^oo e^(-x) d x$.
  - *Límites:* $lim_(h -> 0) frac(f(x+h) - f(x), h)$.
  - *Matrices:* $mat(1, 2, 3; 4, 5, 6; 7, 8, 9)$.
  - *Letras Griegas:* Se escriben directamente por su nombre en minúscula o mayúscula: $alpha, beta, gamma, delta, epsilon, theta, lambda, pi, sigma, omega, Delta, Omega$.

  === Tablas en Formato Académico (Normas APA)

  La plantilla de este proyecto configura automáticamente las tablas bajo el formato académico tradicional de las Normas APA (únicamente líneas horizontales en el encabezado y el cierre, eliminando las líneas verticales).

  Para referenciar y numerar una tabla adecuadamente, se debe envolver la función `#table` dentro de una `#figure` que incluya un título (`caption`) y una etiqueta de anclaje:

  #figure(
    table(
      columns: (auto, 1fr, 1fr),
      align: (left, center, center),
      table.header(
        [*Indicador*], [*Grupo de Control*], [*Grupo Experimental*]
      ),
      [Muestra ($N$)], [50], [50],
      [Media ($mu$)], [14.24], [18.56],
      [Desviación estándar ($sigma$)], [1.12], [0.89],
      [Valor $p$ de significancia], [---], [< 0.001],
    ),
    caption: [Resultados comparativos del desempeño y significancia estadística entre ambos grupos de estudio.],
  ) <tab-indicadores>

  === Inserción de Figuras y Gráficos

  Toda imagen o gráfico ilustrativo debe presentarse en el documento mediante el comando `#figure`, indicando la ruta del archivo mediante `image`, su descripción explicativa y una etiqueta de anclaje para su posterior referencia cruzada:

  #figure(
    image("../assets/uah_logo.png", width: 22%),
    caption: [Logotipo institucional utilizado como ejemplo práctico para la inserción de figuras en Typst.],
  ) <fig-escudo>

  === Gestión de Citas Bibliográficas

  Las fuentes de información de este proyecto se encuentran registradas en el archivo central `bib.yaml`. Para citar una fuente dentro del documento, se escribe el símbolo `@` seguido de la clave de la publicación:

  - *Cita parentética:* Se coloca al final de una afirmación para respaldar los datos expuestos (@floyd_digital_2015).
  - *Cita narrativa:* Se integra de manera fluida en la redacción del texto: Como explican @tocci_digital_2017 en su estudio sobre sistemas...
  - *Cita con página o sección específica:* Permite guiar al lector al punto exacto de la fuente de origen: @mano_digital_2003[p. 145].

  === Referencias Cruzadas Internas

  Typst vincula dinámicamente las referencias a lo largo del documento. Utilizando la sintaxis `@etiqueta` se puede hacer referencia a cualquier elemento etiquetado con `<etiqueta>` (como ecuaciones, tablas y figuras) previamente:

  - *Referencia a ecuaciones:* La formulación matemática de la gravedad se muestra en la @eq-relatividad.
  - *Referencia a tablas:* En la @tab-indicadores se resumen los principales datos del análisis estadístico.
  - *Referencia a figuras:* El escudo representativo institucional se muestra en la @fig-escudo.
  - *Nota sobre secciones:* Para referenciar secciones o encabezados mediante la sintaxis `@etiqueta`, se debe haber habilitado previamente la numeración de encabezados mediante `#set heading(numbering: "1.")`.

  === Bloques de Código Fuente

  Para los trabajos de investigación que involucren metodologías computacionales, algoritmos o análisis de datos, se pueden incluir fragmentos de código fuente con resaltado de sintaxis automático utilizando tres comillas invertidas (\` \` \`) seguidas del nombre del lenguaje:

  ```python
  def analizar_datos(datos):
      # Calcula la media y filtra los valores atípicos
      media = sum(datos) / len(datos)
      filtrados = [x for x in datos if abs(x - media) < 2.0]
      return media, filtrados
  ```
]
