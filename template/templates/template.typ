#import "defintions.typ": font, normal-size, sections
#import "frontpage.typ": frontpage

#let is-last-page = state("is-last-page", false)

#let section(title, body) = {
  heading(level: 1)[#title]
  body

  if title == sections.ref {
    is-last-page.update(true)
  }

  context {
    if is-last-page.get() == false {
      pagebreak()
    }
  }
}

#let t(
  authors: none,
  title: none,
  class: none,
  doc,
) = {
  set document(
    title: title,
    author: authors.map(author => author.name),
  )
  set text(size: normal-size, font: font, lang: "es", region: "VE")
  set page(margin: (top: 4cm, bottom: 3cm, left: 4cm, right: 3cm))
  set par(
    leading: 1em,
    justify: true,
    first-line-indent: (amount: 1.5em, all: true),
    spacing: 0.65em,
  )

  show heading.where(level: 1): it => {
    set align(center)
    set text(size: normal-size)
    block(it.body, above: 1.5em, below: 1.5em)
  }

  show heading.where(level: 2): it => {
    set align(left)
    set par(first-line-indent: (amount: 0em, all: true))
    set text(size: normal-size)
    block(it.body, above: 1.5em, below: 1.5em)
  }

  show heading.where(level: 3): it => {
    set align(left)
    set text(size: normal-size)
    block(emph(it.body), above: 1.5em, below: 1.5em)
  }

  show heading.where(level: 4): it => {
    set align(left)
    set par(first-line-indent: (amount: 0em, all: true))
    set text(size: normal-size)
    block(above: 1.5em, below: 1.5em)[
      #h(1.5em) #it.body
    ]
  }

  show heading.where(level: 5): it => {
    set align(left)
    set par(first-line-indent: (amount: 0em, all: true))
    set text(size: normal-size)
    block(above: 1.5em, below: 1.5em)[
      #h(1.5em) #emph(it.body)
    ]
  }

  let frame(stroke) = (x, y) => (
    left: none,
    right: none,
    top: if y < 2 { stroke } else { 0pt },
    bottom: stroke,
  )

  set table(
    stroke: frame(1pt),
    inset: 10pt,
  )

  let fp = frontpage.with(
    class: class,
    authors: authors,
    title: title,
  )

  show figure: it => {
    set par(first-line-indent: (amount: 0em, all: true))
    let itemId = it.caption.supplement + it.caption.numbering

    block(above: 1.5em, below: 1.5em, width: 100%)[
      #align(left)[
        #block(below: 1em)[
          #itemId
        ]
        #block(above: 1em, below: 1.5em)[
          #emph(it.caption.body)
        ]
      ]
      #set par(justify: false)
      #it.body

    ]
  }

  fp()

  outline()
  pagebreak()

  // set page(numbering: "1", header: [
  //   #set text(8pt)
  //   #smallcaps[#title]
  //   #h(1fr) #counter()
  // ])
  set page(numbering: "1")

  doc

  section(
    sections.ref,
  )[
    #bibliography("../bib.yaml", style: "apa", full: true, title: none)
  ]
}
