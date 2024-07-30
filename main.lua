-- Criação de um mapa de fundo com borda gerada randomicamente

local LG = love.graphics
local Q = love.graphics.newQuad
local K = love.keyboard.isDown

-- Definição das característica do mapa de fundo 
local mapa -- Armazena o mapa
local mapaL, mapaA -- Largura e altura do mapa
local mapaX, mapaY -- Coordenada do mapa
local visaoL, visaoA -- Dimenção do quadro de visão (viewport)
local zoomX, zoomY 

-- Elementos de referência do Quad e gráficos
local qdImagem
local quadro -- Tamanho em pixels do quad
local quadros = {} -- Tabela de quadros configurados
local loteQuadros

function love.load()
  LG.setFont(LG.newFont(16))
  -- Chamar funções personalizadas
  configMapa()
  configVisao()
  configQuadro()
end


function love.draw()
  LG.draw(loteQuadros, math.floor(-zoomX *(mapaX % 1) * quadro), math.floor(-zoomY * (mapaY % 1) * quadro), 0, zoomX, zoomY) 
  LG.print("FPS: " .. love.timer.getFPS(), 10, 20)
end


function love.update(dt)
  if K('up') then 
    moverMapa(0, -0.2 * quadro * dt)
  elseif K ('down') then
    moverMapa(0, 0.2 * quadro * dt)
  end
  if K('left') then
    moverMapa(-0.2 * quadro * dt, 0)
  elseif K('right') then
    moverMapa(0.2 * quadro * dt, 0)
  end
end

-- Funções personalizadas 
function configMapa()
  mapaL = 60
  mapaA = 40
  mapa = {}
  for x = 1, mapaL do
    mapa[x] = {}
    for y = 1, mapaA do 
      mapa[x][y] = love.math.random(0, 3)
    end
  end
end


function configVisao()
  mapaX = 1
  mapaY = 1
  visaoA = 20
  visaoL = 26
  zoomX = 1
  zoomY = 1
end


function configQuadro()
  qdImagem = LG.newImage('mundo.png')
  quadro = 32
  
  -- Coletar os ladrilhos no Sprite
  
  -- Área gramada
  quadros[0] = Q(0 * quadro, 20*quadro, quadro, quadro, qdImagem:getWidth(), qdImagem:getHeight())
  
  
  -- Área piso marrom
  quadros[1] = Q(4 * quadro, 0*quadro, quadro, quadro, qdImagem:getWidth(), qdImagem:getHeight())
  
  
  -- Criar o lote de quadros 
  loteQuadros = LG.newSpriteBatch(qdImagem, visaoL * visaoA)
  modificaLote()
end


function modificaLote()
  -- Limpar o lote antigo 
  loteQuadros:clear()
  
  -- Atualizar os quadros no lote
  for x = 0, visaoL - 1 do
    for y = 0, visaoA - 1 do
      loteQuadros:add(quadros[mapa[x + math.floor(mapaX)][y + math.floor(mapaY)]], x * quadro, y * quadro)
    end
  end
  loteQuadros:flush()
end

function moverMapa(dx, dy)
  velhoX, velhoY = mapaX, mapaY
  
  -- Define os limites físicos do mapa 
  mapaX = math.max(math.min(mapaX + dx, mapaL - visaoL), 1)
  mapaY = math.max(math.min(mapaY + dy, mapaA - visaoA), 1)
  
  -- Verifica se mudou a posição mesmo
  if math.floor(mapaX) ~= math.floor(velhoX) or math.floor(mapaY) ~= math.floor(velhoY) then
    modificaLote()
  end
end

