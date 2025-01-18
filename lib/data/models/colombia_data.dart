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
    nombre: 'Amazonas',
    municipios: [
      'Leticia', 'Puerto Nariño', 'El Encanto', 'La Chorrera', 'La Pedrera',
      'La Victoria', 'Mirití-Paraná', 'Puerto Alegría', 'Puerto Arica',
      'Puerto Santander', 'Tarapacá'
    ],
  ),
  DepartamentoModel(
    nombre: 'Antioquia',
    municipios: [
      'Medellín', 'Abejorral', 'Abriaquí', 'Alejandría', 'Amagá', 'Amalfi', 
      'Andes', 'Angelópolis', 'Angostura', 'Anorí', 'Anzá', 'Apartadó', 
      'Arboletes', 'Argelia', 'Armenia', 'Barbosa', 'Bello', 'Belmira', 
      'Betania', 'Betulia', 'Briceño', 'Buriticá', 'Cáceres', 'Caicedo', 
      'Caldas', 'Campamento', 'Cañasgordas', 'Caracolí', 'Caramanta', 
      'Carepa', 'Carolina del Príncipe', 'Caucasia', 'Chigorodó', 'Cisneros', 
      'Ciudad Bolívar', 'Cocorná', 'Concepción', 'Concordia', 'Copacabana', 
      'Dabeiba', 'Don Matías', 'Ebéjico', 'El Bagre', 'El Carmen de Viboral', 
      'El Peñol', 'El Retiro', 'El Santuario', 'Entrerríos', 'Envigado', 
      'Fredonia', 'Frontino', 'Giraldo', 'Girardota', 'Gómez Plata', 'Granada', 
      'Guadalupe', 'Guarne', 'Guatapé', 'Heliconia', 'Hispania', 'Itagüí', 
      'Ituango', 'Jardín', 'Jericó', 'La Ceja', 'La Estrella', 'La Pintada', 
      'La Unión', 'Liborina', 'Maceo', 'Marinilla', 'Montebello', 'Murindó', 
      'Mutatá', 'Nariño', 'Necoclí', 'Nechí', 'Olaya', 'Peque', 'Pueblorrico', 
      'Puerto Berrío', 'Puerto Nare', 'Puerto Triunfo', 'Remedios', 'Rionegro', 
      'Sabanalarga', 'Sabaneta', 'Salgar', 'San Andrés de Cuerquia', 
      'San Carlos', 'San Francisco', 'San Jerónimo', 'San José de la Montaña', 
      'San Juan de Urabá', 'San Luis', 'San Pedro de los Milagros', 
      'San Pedro de Urabá', 'San Rafael', 'San Roque', 'San Vicente', 
      'Santa Bárbara', 'Santa Fe de Antioquia', 'Santa Rosa de Osos', 
      'Santo Domingo', 'Segovia', 'Sonsón', 'Sopetrán', 'Támesis', 'Tarazá', 
      'Tarso', 'Titiribí', 'Toledo', 'Turbo', 'Uramita', 'Urrao', 
      'Valdivia', 'Valparaíso', 'Vegachí', 'Venecia', 'Vigía del Fuerte', 
      'Yalí', 'Yarumal', 'Yolombó', 'Yondó', 'Zaragoza'
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
    nombre: 'Arauca',
    municipios: [
      'Arauca', 'Arauquita', 'Cravo Norte', 'Fortul', 'Puerto Rondón',
      'Saravena', 'Tame'
    ],
  ),
  DepartamentoModel(
    nombre: 'Atlántico',
    municipios: [
      'Barranquilla', 'Baranoa', 'Campo de la Cruz', 'Candelaria', 
      'Galapa', 'Juan de Acosta', 'Luruaco', 'Malambo', 'Manatí', 
      'Palmar de Varela', 'Piojó', 'Polonuevo', 'Ponedera', 
      'Puerto Colombia', 'Repelón', 'Sabanagrande', 'Sabanalarga', 
      'Santa Lucía', 'Santo Tomás', 'Soledad', 'Suán', 'Tubará', 'Usiacurí'
    ],
  ),
  DepartamentoModel(
    nombre: 'Bogotá D.C.',
    municipios: ['Bogotá'],
  ),
  DepartamentoModel(
    nombre: 'Bolívar',
    municipios: [
      'Cartagena de Indias', 'Achí', 'Altos del Rosario', 'Arenal', 
      'Arjona', 'Arroyohondo', 'Barranco de Loba', 'Calamar', 'Cantagallo', 
      'Cicuco', 'Clemencia', 'Córdoba', 'El Carmen de Bolívar', 'El Guamo', 
      'El Peñón', 'Hatillo de Loba', 'Magangué', 'Mahates', 'Margarita', 
      'María la Baja', 'Montecristo', 'Morales', 'Norosí', 'Pinillos', 
      'Regidor', 'Río Viejo', 'San Cristóbal', 'San Estanislao', 
      'San Fernando', 'San Jacinto', 'San Jacinto del Cauca', 
      'San Juan Nepomuceno', 'San Martín de Loba', 'San Pablo', 
      'Santa Catalina', 'Santa Rosa', 'Santa Rosa del Sur', 'Simití', 
      'Soplaviento', 'Talaigua Nuevo', 'Tiquisio', 'Turbaco', 'Turbana', 
      'Villanueva', 'Zambrano'
    ],
  ),
  DepartamentoModel(
    nombre: 'Boyacá',
    municipios: [
      'Tunja', 'Almeida', 'Aquitania', 'Arcabuco', 'Belén', 'Berbeo', 
      'Betéitiva', 'Boavita', 'Boyacá', 'Briceño', 'Buenavista', 'Busbanzá', 
      'Caldas', 'Campohermoso', 'Cerinza', 'Chinavita', 'Chiquinquirá', 
      'Chiscas', 'Chita', 'Chitaraque', 'Chivatá', 'Chivor', 'Ciénega', 
      'Cómbita', 'Coper', 'Corrales', 'Covarachía', 'Cubará', 'Cucaita', 
      'Cuítiva', 'Duitama', 'El Cocuy', 'El Espino', 'Firavitoba', 'Floresta', 
      'Gachantivá', 'Gámeza', 'Garagoa', 'Guacamayas', 'Guateque', 'Guayatá', 
      'Güicán', 'Iza', 'Jenesano', 'Jericó', 'La Capilla', 'La Uvita', 
      'La Victoria', 'Labranzagrande', 'Macanal', 'Maripí', 'Miraflores', 
      'Mongua', 'Monguí', 'Moniquirá', 'Motavita', 'Muzo', 'Nobsa', 'Nuevo Colón', 
      'Oicatá', 'Otanche', 'Pachavita', 'Páez', 'Paipa', 'Pajarito', 'Panqueba', 
      'Pauna', 'Paya', 'Paz de Río', 'Pesca', 'Pisba', 'Puerto Boyacá', 
      'Quípama', 'Ramiriquí', 'Ráquira', 'Rondón', 'Saboyá', 'Sáchica', 
      'Samacá', 'San Eduardo', 'San José de Pare', 'San Luis de Gaceno', 
      'San Mateo', 'San Miguel de Sema', 'San Pablo de Borbur', 'Santa María', 
      'Santa Rosa de Viterbo', 'Santa Sofía', 'Santana', 'Sativanorte', 
      'Sativasur', 'Siachoque', 'Soatá', 'Socha', 'Socotá', 'Sogamoso', 
      'Somondoco', 'Sora', 'Soracá', 'Sotaquirá', 'Susacón', 'Sutamarchán', 
      'Sutatenza', 'Tasco', 'Tenza', 'Tibaná', 'Tibasosa', 'Tinjacá', 
      'Tipacoque', 'Toca', 'Togüí', 'Tópaga', 'Tota', 'Tununguá', 'Turmequé', 
      'Tuta', 'Tutazá', 'Úmbita', 'Ventaquemada', 'Villa de Leyva', 'Viracachá', 
      'Zetaquira'
    ],
  ),
  DepartamentoModel(
    nombre: 'Caldas',
    municipios: [
      'Manizales', 'Aguadas', 'Anserma', 'Aranzazu', 'Belalcázar', 'Chinchiná',
      'Filadelfia', 'La Dorada', 'La Merced', 'Manzanares', 'Marmato', 'Marquetalia',
      'Marulanda', 'Neira', 'Norcasia', 'Pácora', 'Palestina', 'Pensilvania',
      'Riosucio', 'Risaralda', 'Salamina', 'Samaná', 'San José', 'Supía',
      'Victoria', 'Villamaría', 'Viterbo'
    ],
  ),
  DepartamentoModel(
    nombre: 'Caquetá',
    municipios: [
      'Florencia', 'Albania', 'Belén de los Andaquíes', 'Cartagena del Chairá',
      'Curillo', 'El Doncello', 'El Paujíl', 'La Montañita', 'Milán',
      'Morelia', 'Puerto Rico', 'San José del Fragua', 'San Vicente del Caguán',
      'Solano', 'Solita', 'Valparaíso'
    ],
  ),
  DepartamentoModel(
    nombre: 'Casanare',
    municipios: [
      'Yopal', 'Aguazul', 'Chámeza', 'Hato Corozal', 'La Salina', 'Maní',
      'Monterrey', 'Nunchía', 'Orocué', 'Paz de Ariporo', 'Pore', 'Recetor',
      'Sabanalarga', 'Sácama', 'San Luis de Palenque', 'Támara', 'Tauramena',
      'Trinidad', 'Villanueva'
    ],
  ),
  DepartamentoModel(
    nombre: 'Cauca',
    municipios: [
      'Popayán', 'Almaguer', 'Argelia', 'Balboa', 'Bolívar', 'Buenos Aires',
      'Cajibío', 'Caldono', 'Caloto', 'Corinto', 'El Tambo', 'Florencia',
      'Guachené', 'Guapí', 'Inzá', 'Jambaló', 'La Sierra', 'La Vega',
      'López de Micay', 'Mercaderes', 'Miranda', 'Morales', 'Padilla',
      'Páez', 'Patía', 'Piamonte', 'Piendamó', 'Puerto Tejada', 'Puracé',
      'Rosas', 'San Sebastián', 'Santa Rosa', 'Santander de Quilichao',
      'Silvia', 'Sotará', 'Suárez', 'Sucre', 'Timbío', 'Timbiquí',
      'Toribío', 'Totoró', 'Villa Rica'
    ],
  ),
  DepartamentoModel(
    nombre: 'Cesar',
    municipios: [
      'Valledupar', 'Aguachica', 'Agustín Codazzi', 'Astrea', 'Becerril',
      'Bosconia', 'Chimichagua', 'Chiriguaná', 'Curumaní', 'El Copey',
      'El Paso', 'Gamarra', 'González', 'La Gloria', 'La Jagua de Ibirico',
      'La Paz', 'Manaure Balcón del Cesar', 'Pailitas', 'Pelaya', 'Pueblo Bello',
      'Río de Oro', 'San Alberto', 'San Diego', 'San Martín', 'Tamalameque'
    ],
  ),
  DepartamentoModel(
    nombre: 'Chocó',
    municipios: [
      'Quibdó', 'Acandí', 'Alto Baudó', 'Atrato', 'Bagadó', 'Bahía Solano',
      'Bajo Baudó', 'Bojayá', 'Carmen del Darién', 'Cértegui', 'Condoto',
      'El Cantón del San Pablo', 'El Carmen de Atrato', 'El Litoral del San Juan',
      'Istmina', 'Juradó', 'Lloró', 'Medio Atrato', 'Medio Baudó',
      'Medio San Juan', 'Nóvita', 'Nuquí', 'Río Iró', 'Río Quito',
      'Riosucio', 'San José del Palmar', 'Sipí', 'Tadó', 'Unguía',
      'Unión Panamericana'
    ],
  ),
  DepartamentoModel(
    nombre: 'Córdoba',
    municipios: [
      'Montería', 'Ayapel', 'Buenavista', 'Canalete', 'Cereté', 'Chimá',
      'Chinú', 'Ciénaga de Oro', 'Cotorra', 'La Apartada', 'Los Córdobas',
      'Momil', 'Montelíbano', 'Moñitos', 'Planeta Rica', 'Pueblo Nuevo',
      'Puerto Escondido', 'Puerto Libertador', 'Purísima', 'Sahagún',
      'San Andrés de Sotavento', 'San Antero', 'San Bernardo del Viento',
      'San Carlos', 'San José de Uré', 'San Pelayo', 'Santa Cruz de Lorica',
      'Tierralta', 'Tuchín', 'Valencia'
    ],
  ),
  DepartamentoModel(
    nombre: 'Cundinamarca',
    municipios: [
      'Agua de Dios', 'Albán', 'Anapoima', 'Anolaima', 'Apulo', 'Arbeláez',
      'Beltrán', 'Bituima', 'Bojacá', 'Cabrera', 'Cachipay', 'Cajicá',
      'Caparrapí', 'Cáqueza', 'Carmen de Carupa', 'Chaguaní', 'Chía',
      'Chipaque', 'Choachí', 'Chocontá', 'Cogua', 'Cota', 'Cucunubá',
      'El Colegio', 'El Peñón', 'El Rosal', 'Facatativá', 'Fómeque',
      'Fosca', 'Funza', 'Fúquene', 'Fusagasugá', 'Gachalá', 'Gachancipá',
      'Gachetá', 'Gama', 'Girardot', 'Granada', 'Guachetá', 'Guaduas',
      'Guasca', 'Guataquí', 'Guatavita', 'Guayabal de Síquima', 'Guayabetal',
      'Gutiérrez', 'Jerusalén', 'Junín', 'La Calera', 'La Mesa', 'La Palma',
      'La Peña', 'La Vega', 'Lenguazaque', 'Machetá', 'Madrid', 'Manta',
      'Medina', 'Mosquera', 'Nariño', 'Nemocón', 'Nilo', 'Nimaima',
      'Nocaima', 'Pacho', 'Paime', 'Pandi', 'Paratebueno', 'Pasca',
      'Puerto Salgar', 'Pulí', 'Quebradanegra', 'Quetame', 'Quipile',
      'Ricaurte', 'San Antonio del Tequendama', 'San Bernardo',
      'San Cayetano', 'San Francisco', 'San Juan de Rioseco', 'Sasaima',
      'Sesquilé', 'Sibaté', 'Silvania', 'Simijaca', 'Soacha', 'Sopó',
      'Subachoque', 'Suesca', 'Supatá', 'Susa', 'Sutatausa', 'Tabio',
      'Tausa', 'Tena', 'Tenjo', 'Tibacuy', 'Tibirita', 'Tocaima',
      'Tocancipá', 'Topaipí', 'Ubalá', 'Ubaque', 'Ubaté', 'Une',
      'Útica', 'Venecia', 'Vergara', 'Vianí', 'Villagómez', 'Villapinzón',
      'Villeta', 'Viotá', 'Yacopí', 'Zipacón', 'Zipaquirá'
    ],
  ),
  DepartamentoModel(
    nombre: 'Guainía',
    municipios: [
      'Inírida', 'Barranco Minas', 'Mapiripana', 'San Felipe', 'Puerto Colombia',
      'La Guadalupe', 'Cacahual', 'Pana Pana', 'Morichal'
    ],
  ),
  DepartamentoModel(
    nombre: 'Guaviare',
    municipios: [
      'San José del Guaviare', 'Calamar', 'El Retorno', 'Miraflores'
    ],
  ),
  DepartamentoModel(
    nombre: 'Huila',
    municipios: [
      'Neiva', 'Acevedo', 'Agrado', 'Aipe', 'Algeciras', 'Altamira',
      'Baraya', 'Campoalegre', 'Colombia', 'Elías', 'Garzón', 'Gigante',
      'Guadalupe', 'Hobo', 'Íquira', 'Isnos', 'La Argentina', 'La Plata',
      'Nátaga', 'Oporapa', 'Paicol', 'Palermo', 'Palestina', 'Pital',
      'Pitalito', 'Rivera', 'Saladoblanco', 'San Agustín', 'Santa María',
      'Suaza', 'Tarqui', 'Tello', 'Teruel', 'Tesalia', 'Timaná', 'Villavieja',
      'Yaguará'
    ],
  ),
  DepartamentoModel(
    nombre: 'La Guajira',
    municipios: [
      'Riohacha', 'Albania', 'Barrancas', 'Dibulla', 'Distracción',
      'El Molino', 'Fonseca', 'Hatonuevo', 'La Jagua del Pilar', 'Maicao',
      'Manaure', 'San Juan del Cesar', 'Uribia', 'Urumita', 'Villanueva'
    ],
  ),
  DepartamentoModel(
    nombre: 'Magdalena',
    municipios: [
      'Santa Marta', 'Algarrobo', 'Aracataca', 'Ariguaní', 'Cerro de San Antonio',
      'Chivolo', 'Ciénaga', 'Concordia', 'El Banco', 'El Piñón', 'El Retén',
      'Fundación', 'Guamal', 'Nueva Granada', 'Pedraza', 'Pijiño del Carmen',
      'Pivijay', 'Plato', 'Puebloviejo', 'Remolino', 'Sabanas de San Ángel',
      'Salamina', 'San Sebastián de Buenavista', 'San Zenón', 'Santa Ana',
      'Santa Bárbara de Pinto', 'Sitionuevo', 'Tenerife', 'Zapayán', 'Zona Bananera'
    ],
  ),
  DepartamentoModel(
    nombre: 'Meta',
    municipios: [
      'Villavicencio', 'Acacías', 'Barranca de Upía', 'Cabuyaro', 'Castilla la Nueva',
      'Cubarral', 'Cumaral', 'El Calvario', 'El Castillo', 'El Dorado',
      'Fuente de Oro', 'Granada', 'Guamal', 'La Macarena', 'La Uribe',
      'Lejanías', 'Mapiripán', 'Mesetas', 'Puerto Concordia', 'Puerto Gaitán',
      'Puerto Lleras', 'Puerto López', 'Puerto Rico', 'Restrepo', 'San Carlos de Guaroa',
      'San Juan de Arama', 'San Juanito', 'San Martín', 'Vista Hermosa'
    ],
  ),
  DepartamentoModel(
    nombre: 'Nariño',
    municipios: [
      'Pasto', 'Albán', 'Aldana', 'Ancuyá', 'Arboleda', 'Barbacoas',
      'Belén', 'Buesaco', 'Chachagüí', 'Colón', 'Consacá', 'Contadero',
      'Córdoba', 'Cuaspud', 'Cumbal', 'Cumbitara', 'El Charco', 'El Peñol',
      'El Rosario', 'El Tablón de Gómez', 'El Tambo', 'Francisco Pizarro',
      'Funes', 'Guachucal', 'Guaitarilla', 'Gualmatán', 'Iles', 'Imués',
      'Ipiales', 'La Cruz', 'La Florida', 'La Llanada', 'La Tola',
      'La Unión', 'Leiva', 'Linares', 'Los Andes', 'Magüí Payán', 'Mallama',
      'Mosquera', 'Nariño', 'Olaya Herrera', 'Ospina', 'Policarpa',
      'Potosí', 'Providencia', 'Puerres', 'Pupiales', 'Ricaurte',
      'Roberto Payán', 'Samaniego', 'San Bernardo', 'San Lorenzo',
      'San Pablo', 'San Pedro de Cartago', 'Sandoná', 'Santa Bárbara',
      'Santacruz', 'Sapuyes', 'Taminango', 'Tangua', 'Tumaco', 'Túquerres',
      'Yacuanquer'
    ],
  ),
  DepartamentoModel(
    nombre: 'Norte de Santander',
    municipios: [
      'Cúcuta', 'Ábrego', 'Arboledas', 'Bochalema', 'Bucarasica', 'Cáchira',
      'Cácota', 'Chinácota', 'Chitagá', 'Convención', 'Cucutilla', 'Durania',
      'El Carmen', 'El Tarra', 'El Zulia', 'Gramalote', 'Hacarí',
      'Herrán', 'La Esperanza', 'La Playa', 'Labateca', 'Los Patios',
      'Lourdes', 'Mutiscua', 'Ocaña', 'Pamplona', 'Pamplonita',
      'Puerto Santander', 'Ragonvalia', 'Salazar', 'San Calixto',
      'San Cayetano', 'Santiago', 'Sardinata', 'Silos', 'Teorama',
      'Tibú', 'Toledo', 'Villa Caro', 'Villa del Rosario'
    ],
  ),
  DepartamentoModel(
    nombre: 'Putumayo',
    municipios: [
      'Mocoa', 'Colón', 'Orito', 'Puerto Asís', 'Puerto Caicedo',
      'Puerto Guzmán', 'Puerto Leguízamo', 'San Francisco', 'San Miguel',
      'Santiago', 'Sibundoy', 'Valle del Guamuez', 'Villagarzón'
    ],
  ),
  DepartamentoModel(
    nombre: 'Quindío',
    municipios: [
      'Armenia', 'Buenavista', 'Calarcá', 'Circasia', 'Córdoba',
      'Filandia', 'Génova', 'La Tebaida', 'Montenegro', 'Pijao',
      'Quimbaya', 'Salento'
    ],
  ),
  DepartamentoModel(
    nombre: 'Risaralda',
    municipios: [
      'Pereira', 'Apía', 'Balboa', 'Belén de Umbría', 'Dosquebradas',
      'Guática', 'La Celia', 'La Virginia', 'Marsella', 'Mistrató',
      'Pueblo Rico', 'Quinchía', 'Santa Rosa de Cabal', 'Santuario'
    ],
  ),
  DepartamentoModel(
    nombre: 'San Andrés y Providencia',
    municipios: [
      'San Andrés', 'Providencia'
    ],
  ),
  DepartamentoModel(
    nombre: 'Santander',
    municipios: [
      'Bucaramanga', 'Aguada', 'Albania', 'Aratoca', 'Barbosa', 'Barichara',
      'Barrancabermeja', 'Betulia', 'Bolívar', 'Cabrera', 'California',
      'Capitanejo', 'Carcasí', 'Cepitá', 'Cerrito', 'Charalá', 'Charta',
      'Chima', 'Chipatá', 'Cimitarra', 'Concepción', 'Confines', 'Contratación',
      'Coromoro', 'Curití', 'El Carmen de Chucurí', 'El Guacamayo', 'El Peñón',
      'El Playón', 'Encino', 'Enciso', 'Florián', 'Floridablanca', 'Galán',
      'Gámbita', 'Girón', 'Guaca', 'Guadalupe', 'Guapotá', 'Guavatá',
      'Güepsa', 'Hato', 'Jesús María', 'Jordán', 'La Belleza', 'La Paz',
      'Landázuri', 'Lebrija', 'Los Santos', 'Macaravita', 'Málaga', 'Matanza',
      'Mogotes', 'Molagavita', 'Ocamonte', 'Oiba', 'Onzaga', 'Palmar',
      'Palmas del Socorro', 'Páramo', 'Piedecuesta', 'Pinchote', 'Puente Nacional',
      'Puerto Parra', 'Puerto Wilches', 'Rionegro', 'Sabana de Torres',
      'San Andrés', 'San Benito', 'San Gil', 'San Joaquín', 'San José de Miranda',
      'San Miguel', 'San Vicente de Chucurí', 'Santa Bárbara', 'Santa Helena del Opón',
      'Simacota', 'Socorro', 'Suaita', 'Sucre', 'Suratá', 'Tona', 'Valle de San José',
      'Vélez', 'Vetas', 'Villanueva', 'Zapatoca'
    ],
  ),
  DepartamentoModel(
    nombre: 'Sucre',
    municipios: [
      'Sincelejo', 'Buenavista', 'Caimito', 'Chalán', 'Colosó', 'Corozal',
      'Coveñas', 'El Roble', 'Galeras', 'Guaranda', 'La Unión', 'Los Palmitos',
      'Majagual', 'Morroa', 'Ovejas', 'Palmito', 'Sampués', 'San Benito Abad',
      'San Juan de Betulia', 'San Marcos', 'San Onofre', 'San Pedro',
      'Santiago de Tolú', 'Sincé', 'Sucre', 'Tolú Viejo'
    ],
  ),
]; 