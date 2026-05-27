#import "@preview/datify:0.1.4": custom-date-format, month-name
#import "defintions.typ": font, normal-size

#let logo = image("../assets/uah_logo.png", width: 100%)

#let frontpage(
  class: none,
  authors: none,
  title: none,
) = {
  let seccion = class.schedule + class.classNumber

  table(
    columns: (.4fr, 1fr),
    align: (center, center),
    stroke: none,
    inset: 0.1cm,
    logo,
    [
      #set text(size: normal-size, font: font, weight: "bold")
      Universidad Alejandro de Humboldt \
      Facultad de Ingeniería \
      Escuela de Ingeniería Informática \
      #class.name \
      Sección: #seccion \
      #class.professor \
    ],
  )

  v(30%)
  set align(center)
  set text(size: normal-size, font: font, weight: "bold")
  upper(title)

  v(20%)
  set align(right)
  set text(size: normal-size, font: font, weight: "regular")
  for author in authors {
    align(right)[
      #author.name #author.id
    ]
  }

  let td = datetime.today()
  let year = custom-date-format(td, "MMMM YYYY", "es")
  let date-string = "Caracas, " + year

  place(bottom + center, date-string)
  pagebreak()
}
