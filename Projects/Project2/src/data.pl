% Objetivo: otimizar recursos e obter maximo lucro.
% Cada obra tem um valor de venda .
% Cada obra tem uma data limite.
% Se a obra terminar antes da data limite há um bonus.
% Se a obra terminar depois da data limite há penalização.
% O bonus/penalizacao tem a ver com o numero de dias de diferenca entre o estipulado e o terminado.
% Cada obra tem um conjunto operacoes especificas(trabalhadores especializados, material especifico).
% Cada trabalhador pode ter mais que 1 especialidade ou ser indiferenciado.
% Cada material tem um custo.
% Cada trabalhador tem um custo(Quantas mais especialidades tiver mais bem pago é).
% Podem haver dependencias/ordem nas operaçoes durante a obra.
% Cada fase de especialidade tem um duracao e precisa de pelo menos 1 trabalhador da especialidade.
% Dependendo do numero de pessoas alocadas para um fase de especialidade, esta pode ter duracao variavel.
% Todos os materiais e trabalhadores estao sempre disponiveis a serem utilizados.
% Os materiais e trabalhadores podem ter custos diferentes dependendo di dia.

%   constructionOperation(Id, Name, speacialty, listOfWorkers, listOfMaterials)
constructionOperation(0, 'Paintwork', '', [], listOfMaterials).
constructionOperation(1, 'Plumbing & Drainage', '', [], listOfMaterials).
constructionOperation(2, 'Masonary', '', [], listOfMaterials).
constructionOperation(3, 'Waterproofing', '', [], listOfMaterials).
constructionOperation(4, 'EarthWorks', '', [], listOfMaterials).
constructionOperation(5, 'Plumbing ', '', [], listOfMaterials).
constructionOperation(6, 'Ceilings', '', [], listOfMaterials).
constructionOperation(7, 'Glazing', '', [], listOfMaterials).
constructionOperation(8, 'Pre-Cast Concrete', '', [], listOfMaterials).
constructionOperation(9, 'Tiling', '', [], listOfMaterials).
constructionOperation(10, 'External Work', '', [], listOfMaterials).
constructionOperation(11, 'Eletrical Wiring', '', [], listOfMaterials).

%   worker(Id, Name, ListOfSpeacialty, Salary)
worker(0, 'Oliver', ['Electrician'], 300).
worker(1, 'Jack', ['Carpenter'], 150).
worker(2, 'Charlie', ['Mason'], 150).
worker(3, 'Oscar', ['Engineer', 'Electrician', 'Technician'], 1050).
worker(4, 'James', ['Plumber', 'Carpenter'], 300).
worker(5, 'William', ['Tiler'], 150).
worker(6, 'Thomas', ['Technician'], 250).
worker(7, 'Harry', ['Engineer', 'Technician'], 750).
worker(8, 'Emily', ['Painter', 'Carpenter'], 300).
worker(9, 'Olivia', ['Engineer'], 500).
worker(10, 'Jessica', ['Director'], 900).
worker(11, 'Ava', ['Technician'], 250).
worker(12, 'Isabella', ['Project Manager'], 700).
worker(13, 'Mia', [], 100).
worker(14, 'Charlotte', [], 100).
worker(15, 'Richard', [], 100).
worker(16, 'Robert', [], 100).

%   materialAndEquipment(Id, Name, Cost)
materialAndEquipment(0, 'Measuring Tape', 5).
materialAndEquipment(1, 'Eletrical Wiring', 200).
materialAndEquipment(2, 'Steel', 100).
materialAndEquipment(4, 'Wood', 50).
materialAndEquipment(5, 'Glass', 45).
materialAndEquipment(6, 'Stone', 70).
materialAndEquipment(7, 'Cement', 150).
materialAndEquipment(8, 'Safety Helment', 40).
materialAndEquipment(9, 'Safety Vest', 50).
materialAndEquipment(10, 'Gloves', 10).
materialAndEquipment(11, 'Elevator', 2000).
materialAndEquipment(12, 'Escalator', 10000).
materialAndEquipment(13, 'Switches', 200).
materialAndEquipment(14, 'Pickaxe', 40).
materialAndEquipment(15, 'Shovel', 13).
materialAndEquipment(16, 'Crane', 7000).
materialAndEquipment(17, 'Excavator', 13000).
materialAndEquipment(18, 'Bulldozers', 15000).
materialAndEquipment(19, 'Trucks', 9000).