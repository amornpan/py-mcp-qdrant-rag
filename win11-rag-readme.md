# MSSQL Server for RAG สำหรับ Windows 11

คู่มือนี้จะแนะนำวิธีการติดตั้งและใช้งาน pyRAGDocs โดยใช้ Conda เป็นตัวจัดการแพ็กเกจและสภาพแวดล้อม

## ข้อกำหนดก่อนเริ่มต้น - ไม่มีไม่ได้ครับ

1. [Miniconda](https://www.anaconda.com/docs/getting-started/miniconda/install#windows-installation) (หรือ Anaconda)
   * หากยังไม่มี ให้ติดตั้ง miniconda ตามลิงก์ด้านบน
   * *** เราสามารถใช้ miniconda แทน conda ได้
2. [Qdrant](https://qdrant.tech/) (vector database สำหรับเก็บ embeddings)
3. [Ollama](https://ollama.ai/) (สำหรับสร้าง embeddings แบบ local) หรือ API key ของ OpenAI

## วิธีการติดตั้ง MSSQL Server for RAG เฉพาะกรณียังไม่เคยติดตั้งมาก่อน

### 1. ติดตั้ง python และ framework ที่เกี่ยวข้อง ด้วย conda
```batch
rem ติดตั้ง python และ framework ที่เกี่ยวข้อง
conda env create -f environment.yml
rem เปิดใช้งานสิ่งที่ติดตั้งไป (environment)
conda activate mcp-rag-qdrant-1.0
pip install ollama

ollama pull nomic-embed-text
```

หากมี error ให้สอบถาม TA ห้ามไปต่อ!!!

### 2. ตรวจสอบ path ของ python ติดตั้ง
```batch
where python
```

copy หรือ จดไว้ เดี๋ยวจะต้องนำ path ของ python นี้ไปใช้

### 3. ตั้งค่า Claude Desktop

ค้นหา claude_desktop_config.json ที่อาจอยู่ในตำแหน่งต่อไปนี้:
- `C:\Users\%USERNAME%\AppData\Roaming\Claude\claude_desktop_config.json`
- `C:\Users\%USERNAME%\AppData\Local\Claude\claude_desktop_config.json`

หากไม่พบ สามารถใช้ Windows Search ค้นหาคำว่า "claude_desktop_config.json"
หรือใช้คำสั่งใน Command Prompt: `dir C:\claude_desktop_config.json /s /p`
หากไม่พบ ให้สอบถาม TA

เพิ่มการตั้งค่าต่อไปนี้ (แทนที่ `C:/path/to/your/python.exe` ด้วย path ของ python ที่ได้จากขั้นตอนที่ 2):

```json
{
  "mcpServers": {
    "mcp-rag-qdrant-1.0": {
      "command": "C:/path/to/your/python.exe",
      "args": [
        "C:/path/to/your/run.py",
        "--mode",
        "mcp"
      ],
      "env": {
        "QDRANT_URL": "http://34.27.111.38:6333",
        "EMBEDDING_PROVIDER": "ollama",
        "OLLAMA_URL": "http://localhost:11434"
      }
    }
  }
}
```

หมายเหตุ: ใน Windows ควรใช้ forward slash (/) แทน backslash (\\) ในไฟล์ JSON
ทบทวนว่าได้เปลี่ยน path ครบถ้วนถูกต้องแล้วหรือยัง หากทำแล้วให้บันทึกและปิด

### 4. รีสตาร์ท Claude Desktop และเริ่มใช้งาน

## วิธีแก้ไขปัญหาทั่วไป

### ถ้า MCP Server ไม่สามารถเชื่อมต่อกับ Qdrant หรือ Ollama

1. ตรวจสอบว่า Qdrant และ Ollama กำลังทำงานอยู่และสามารถเข้าถึงได้
2. ตรวจสอบว่าข้อมูลการเชื่อมต่อ (URL) ถูกต้อง
3. ตรวจสอบการตั้งค่า Windows Firewall ว่าอนุญาตให้เชื่อมต่อกับบริการดังกล่าวหรือไม่
4. ลองเชื่อมต่อจากเครือข่ายอื่นเพื่อตรวจสอบว่าเป็นปัญหาเครือข่ายหรือไม่

### ถ้า Claude Desktop ไม่เห็น MCP Server

1. ตรวจสอบการตั้งค่าใน `claude_desktop_config.json`
2. ตรวจสอบว่าได้กำหนดเส้นทางที่ถูกต้องของ Python และสคริปต์ MCP Server
3. ตรวจสอบบันทึกของ Claude Desktop ที่:
   ```batch
   type "%USERPROFILE%\AppData\Local\Claude\Logs\mcp*.log"
   ```
   หรือ
   ```batch
   type "%USERPROFILE%\AppData\Roaming\Claude\Logs\mcp*.log"
   ```

## ข้อความปฏิเสธความรับผิดชอบ (Disclaimer)

ซอฟต์แวร์ "MSSQL Server for RAG" ("ซอฟต์แวร์") จัดทำขึ้นเพื่อวัตถุประสงค์ทางการศึกษาเท่านั้น ผู้พัฒนาและผู้สอนรวมถึงคณะทำงานที่เกี่ยวข้องไม่รับประกันความถูกต้อง ความสมบูรณ์ หรือความเหมาะสมสำหรับวัตถุประสงค์เฉพาะใดๆ ของซอฟต์แวร์นี้ ไม่ว่าจะโดยชัดแจ้งหรือโดยนัย

การใช้ซอฟต์แวร์นี้เป็นความรับผิดชอบของผู้ใช้แต่เพียงผู้เดียว ผู้พัฒนาและผู้สอนรวมถึงคณะทำงานที่เกี่ยวข้องจะไม่รับผิดชอบต่อความเสียหายใดๆ ทั้งทางตรง ทางอ้อม อุบัติเหตุ พิเศษ หรือเป็นผลสืบเนื่อง รวมถึงแต่ไม่จำกัดเพียงการสูญเสียข้อมูล การสูญเสียกำไร หรือการหยุดชะงักทางธุรกิจ อันเกิดจากการใช้หรือการไม่สามารถใช้ซอฟต์แวร์นี้ได้ แม้ว่าจะได้รับคำแนะนำถึงความเป็นไปได้ของความเสียหายดังกล่าวแล้วก็ตาม

ผู้ใช้รับทราบว่าซอฟต์แวร์นี้อาจมีข้อบกพร่องหรือความผิดพลาด และยอมรับความเสี่ยงทั้งหมดอันเกี่ยวเนื่องกับคุณภาพ ประสิทธิภาพ ความถูกต้อง และการทำงานของซอฟต์แวร์

ผู้ใช้ต้องปฏิบัติตามกฎหมาย ระเบียบ และข้อบังคับที่เกี่ยวข้องทั้งหมดในการใช้ซอฟต์แวร์นี้ รวมถึงแต่ไม่จำกัดเพียงกฎหมายคุ้มครองข้อมูลส่วนบุคคล กฎหมายลิขสิทธิ์ และข้อตกลงการอนุญาตใช้สิทธิใดๆ ที่เกี่ยวข้อง

การใช้ซอฟต์แวร์นี้ถือเป็นการยอมรับข้อกำหนดและเงื่อนไขทั้งหมดที่ระบุไว้ในข้อความปฏิเสธความรับผิดชอบนี้