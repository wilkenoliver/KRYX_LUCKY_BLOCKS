# 🍀 Kryx Lucky Blocks | Enhanced

Script para Roblox com interface em **Rayfield**, que permite spawnar todos os tipos de blocos e usar ferramentas de jogador. Esta versão traz uma interface reorganizada, em português, com sliders, notificações e uma aba de configurações.

> Script original por **Kryx** (open source). Interface melhorada e adaptada por **FAL**.

---

## ✨ Funcionalidades

### 🍀 Aba Blocos
- Spawn de **Lucky, Super, Diamond, Rainbow, Galaxy, Void e Limited Block**
- Notificações de confirmação a cada spawn
- Aviso caso o remote do bloco não exista no jogo
- Os blocos caem no seu terreno: é só andar sobre eles para abrir

### 🏃 Aba Jogador
- **Slider de WalkSpeed** (16 a 200) com valor visível
- **Ativar Velocidade** (toggle)
- **Pulo Infinito** (toggle)
- **Godmode** (toggle)
- **Teleporte para jogador**, com lista de jogadores atualizada automaticamente

### ⚙️ Aba Configurações
- Seleção de tema: Dark, Neon, Purple e Ocean
- Cor de destaque em hexadecimal
- Transparência da janela
- Escala da UI

> ⚠️ **Observação:** as opções da aba Configurações ainda estão em desenvolvimento. O Rayfield tem suporte limitado para alterar o visual em tempo real, então por enquanto os valores são apenas armazenados no script.

---

## 📥 Como usar

1. Tenha um executor de scripts compatível com Roblox.
2. Abra o jogo desejado.
3. Copie e execute o código abaixo:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/SEU_USUARIO/SEU_REPOSITORIO/main/script.lua"))()
```

Ou, se preferir, copie o conteúdo do arquivo `script.lua` e cole direto no executor.

---

## 📁 Estrutura do repositório

```
📦 SEU_REPOSITORIO
 ┣ 📜 script.lua    # Script principal
 ┣ 📜 README.md     # Este arquivo
 ┗ 📷 screenshots/  # Prints da interface (opcional)
```

---

## 🖼️ Screenshots

Adicione prints da interface na pasta `screenshots/` e referencie aqui:

```md
![Aba Blocos](screenshots/blocos.png)
![Aba Jogador](screenshots/jogador.png)
```

---

## 🛠️ Detalhes técnicos

- **UI:** [Rayfield](https://sirius.menu/rayfield)
- **Linguagem:** Lua (Luau)
- Conexões de eventos são registradas e desconectadas automaticamente ao recarregar o script (função de cleanup)
- Executar o script novamente remove a versão anterior antes de carregar a nova

---

## ⚠️ Aviso

- Este script **não é verificado** pelo rscripts.net. Use com cautela.
- O uso de scripts pode violar os Termos de Serviço do Roblox e resultar em punições na conta. **Use por sua conta e risco.**
- Nunca faça login em sites falsos do Roblox. Links oficiais sempre terminam em `roblox.com`.
- Este projeto é apenas para fins educacionais e não tem afiliação com a Roblox Corporation.

---

## 🙌 Créditos

| Função | Autor |
|---|---|
| Script original | **Kryx** |
| Interface melhorada e tradução | **FAL** |
| Biblioteca de UI | Rayfield (Sirius) |

---

## 📄 Licença

Distribuído sob a licença **MIT**. Consulte o arquivo `LICENSE` para mais detalhes. Respeite os créditos do autor original.

---

<p align="center">Feito pelo FAL 💚</p>
