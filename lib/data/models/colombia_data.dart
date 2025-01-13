class DepartamentoModel {
  final String nombre;
  final List<String> municipios;
  final Map<String, List<String>>? comunasCorregimientos;

  DepartamentoModel({
    required this.nombre, 
    required this.municipios, 
    this.comunasCorregimientos,
  });
}

final List<DepartamentoModel> departamentosColombia = [
  DepartamentoModel(
    nombre: 'Antioquia',
    municipios: [
      'Medellín', 'Bello', 'Itagüí', 'Envigado', 'Sabaneta', 'La Estrella', 
      'Caldas', 'Copacabana', 'Girardota', 'Barbosa', 'Rionegro', 'La Ceja',
      'Marinilla', 'El Carmen de Viboral', 'Guarne'
    ],
    comunasCorregimientos: {
      'Medellín': [
        'Comuna 1 - Popular',
        'Comuna 2 - Santa Cruz',
        'Comuna 3 - Manrique',
        'Comuna 4 - Aranjuez',
        'Comuna 5 - Castilla',
        'Comuna 6 - Doce de Octubre',
        'Comuna 7 - Robledo',
        'Comuna 8 - Villa Hermosa',
        'Comuna 9 - Buenos Aires',
        'Comuna 10 - La Candelaria',
        'Comuna 11 - Laureles-Estadio',
        'Comuna 12 - La América',
        'Comuna 13 - San Javier',
        'Comuna 14 - El Poblado',
        'Comuna 15 - Guayabal',
        'Comuna 16 - Belén',
        'Corregimiento San Sebastián de Palmitas',
        'Corregimiento San Cristóbal',
        'Corregimiento Altavista',
        'Corregimiento San Antonio de Prado',
        'Corregimiento Santa Elena',
      ],
    },
  ),
  DepartamentoModel(
    nombre: 'Atlántico',
    municipios: [
      'Barranquilla', 'Soledad', 'Malambo', 'Puerto Colombia', 'Galapa',
      'Sabanalarga', 'Baranoa', 'Santo Tomás', 'Palmar de Varela'
    ],
  ),
  DepartamentoModel(
    nombre: 'Bogotá D.C.',
    municipios: ['Bogotá'],
  ),
  DepartamentoModel(
    nombre: 'Bolívar',
    municipios: [
      'Cartagena', 'Magangué', 'Arjona', 'Turbaco', 'Carmen de Bolívar',
      'San Juan Nepomuceno', 'Santa Rosa del Sur'
    ],
  ),
  DepartamentoModel(
    nombre: 'Boyacá',
    municipios: [
      'Tunja', 'Duitama', 'Sogamoso', 'Chiquinquirá', 'Paipa',
      'Villa de Leyva', 'Puerto Boyacá', 'Moniquirá'
    ],
  ),
  DepartamentoModel(
    nombre: 'Caldas',
    municipios: [
      'Manizales', 'La Dorada', 'Chinchiná', 'Villamaría', 'Anserma',
      'Aguadas', 'Riosucio', 'Salamina'
    ],
  ),
  DepartamentoModel(
    nombre: 'Caquetá',
    municipios: [
      'Florencia', 'San Vicente del Caguán', 'Puerto Rico', 'El Doncello',
      'Cartagena del Chairá', 'El Paujil'
    ],
  ),
  DepartamentoModel(
    nombre: 'Cauca',
    municipios: [
      'Popayán', 'Santander de Quilichao', 'Puerto Tejada', 'Patía',
      'Miranda', 'Caloto', 'Piendamó'
    ],
  ),
  DepartamentoModel(
    nombre: 'Cesar',
    municipios: [
      'Valledupar', 'Aguachica', 'Agustín Codazzi', 'La Paz',
      'Bosconia', 'El Copey', 'San Alberto'
    ],
  ),
  DepartamentoModel(
    nombre: 'Córdoba',
    municipios: [
      'Montería', 'Lorica', 'Sahagún', 'Cereté', 'Planeta Rica',
      'Montelíbano', 'Tierralta'
    ],
  ),
  DepartamentoModel(
    nombre: 'Cundinamarca',
    municipios: [
      'Soacha', 'Facatativá', 'Zipaquirá', 'Chía', 'Mosquera',
      'Madrid', 'Funza', 'Cajicá', 'Sibaté', 'La Calera'
    ],
  ),
  DepartamentoModel(
    nombre: 'Chocó',
    municipios: [
      'Quibdó', 'Istmina', 'Tadó', 'Bahía Solano', 'Acandí',
      'Condoto', 'Riosucio'
    ],
  ),
  DepartamentoModel(
    nombre: 'Huila',
    municipios: [
      'Neiva', 'Pitalito', 'Garzón', 'La Plata', 'Campoalegre',
      'Gigante', 'Palermo'
    ],
  ),
  DepartamentoModel(
    nombre: 'La Guajira',
    municipios: [
      'Riohacha', 'Maicao', 'Uribia', 'San Juan del Cesar', 'Fonseca',
      'Villanueva', 'Barrancas'
    ],
  ),
  DepartamentoModel(
    nombre: 'Magdalena',
    municipios: [
      'Santa Marta', 'Ciénaga', 'Fundación', 'Aracataca', 'Plato',
      'El Banco', 'Zona Bananera'
    ],
  ),
  DepartamentoModel(
    nombre: 'Meta',
    municipios: [
      'Villavicencio', 'Acacías', 'Granada', 'Puerto López', 'La Macarena',
      'San Martín', 'Puerto Gaitán'
    ],
  ),
  DepartamentoModel(
    nombre: 'Nariño',
    municipios: [
      'Pasto', 'Ipiales', 'Tumaco', 'Túquerres', 'La Unión',
      'Samaniego', 'Sandoná'
    ],
  ),
  DepartamentoModel(
    nombre: 'Norte de Santander',
    municipios: [
      'Cúcuta', 'Ocaña', 'Villa del Rosario', 'Los Patios', 'Pamplona',
      'Tibú', 'El Zulia'
    ],
  ),
  DepartamentoModel(
    nombre: 'Quindío',
    municipios: [
      'Armenia', 'Calarcá', 'Montenegro', 'La Tebaida', 'Quimbaya',
      'Circasia', 'Filandia'
    ],
  ),
  DepartamentoModel(
    nombre: 'Risaralda',
    municipios: [
      'Pereira', 'Dosquebradas', 'Santa Rosa de Cabal', 'La Virginia',
      'Belén de Umbría', 'Quinchía', 'Marsella'
    ],
  ),
  DepartamentoModel(
    nombre: 'Santander',
    municipios: [
      'Bucaramanga', 'Floridablanca', 'Girón', 'Piedecuesta', 'Barrancabermeja',
      'San Gil', 'Socorro'
    ],
  ),
  DepartamentoModel(
    nombre: 'Sucre',
    municipios: [
      'Sincelejo', 'Corozal', 'San Marcos', 'San Onofre', 'Tolú',
      'Santiago de Tolú', 'Sampués'
    ],
  ),
  DepartamentoModel(
    nombre: 'Tolima',
    municipios: [
      'Ibagué', 'Espinal', 'Melgar', 'Chaparral', 'Mariquita',
      'Honda', 'Líbano'
    ],
  ),
  DepartamentoModel(
    nombre: 'Valle del Cauca',
    municipios: [
      'Cali', 'Buenaventura', 'Palmira', 'Tuluá', 'Cartago',
      'Buga', 'Yumbo', 'Jamundí'
    ],
  ),
]; 