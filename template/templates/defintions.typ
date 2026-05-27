#let normal-size = 12pt
#let font = "Times New Roman"

#let left = left + horizon
#let center = center + horizon

#let sections = (
  intro: "Introducción",
  des: "Desarrollo",
  conc: "Conclusión",
  ref: "Referencias Bibliográficas",
)

#let classesNames = (
  computacionGrafica: "Computación Gráfica",
  circuitosElectronicos: "Circuitos Electrónicos",
)

#let professors = (
  computacionGrafica: "Christian Freites",
  circuitosElectronicos: "Franklin Cedeño",
)

#let classNumbers = (
  computacionGrafica: "0601",
  circuitosElectronicos: "0701",
)

#let schedules = (
  morning: "DCM",
  night: "DCN",
)

#let classes = (
  computacionGrafica: (
    name: classesNames.computacionGrafica,
    professor: professors.computacionGrafica,
    classNumber: classNumbers.computacionGrafica,
    schedule: schedules.night,
  ),
  circuitosElectronicos: (
    name: classesNames.circuitosElectronicos,
    professor: professors.circuitosElectronicos,
    classNumber: classNumbers.circuitosElectronicos,
    schedule: schedules.night,
  ),
)


