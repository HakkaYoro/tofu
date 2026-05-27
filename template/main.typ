#import "./templates/template.typ": section, t
#import "./templates/defintions.typ": classes, sections

#show: t.with(
  authors: (
    (name: "Manuel Cerrano", id: "34.567.890"),
  ),
  title: "Sistemas Numéricos y los Códigos",
  class: classes.circuitosElectronicos,
)

#section(
  sections.intro,
)[
  #include "sections/intro.typ"
]


#section(
  sections.des,
)[
  #include "sections/des.typ"
]

#section(
  sections.conc,
)[
  #include "sections/con.typ"
]

