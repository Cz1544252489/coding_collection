pip install beautifulsoup4
getMainLink(){
  if [ ! -f mainLink.txt ]; then
    touch mainLink.txt
  fi
#  for i in $(seq 130 142); do
  for i in $(seq 143 151); do
    echo "https://scicol.shu.edu.cn/sy/xsbg/${i}.htm" >> mainLink.txt
  done
}

getListLink(){
  if [ ! -f links.txt ]; then
    touch links.txt
  fi
  if [ -f mainLink.txt ]; then
    for L in $(cat mainLink.txt); do
      echo $L
      wget -q $L -O list.htm
      python test1.py | sed -E "s/^.{5}/https\:\/\/scicol\.shu\.edu\.cn/" >> links.txt
      echo "stop 1sec"
      sleep 1
    done
  fi
  rm list.htm mainLink.txt
}

build_python(){
cat > test.py << EOF
from bs4 import BeautifulSoup

with open("test.htm", "r", encoding="utf-8") as f:
    soup = BeautifulSoup(f, "html.parser")

divs = soup.find_all("div", class_="v_news_content")
print(divs[0].find_all('p')[0])
print(divs[0].find_all('p')[1])
print(divs[0].find_all('p')[2])
print(divs[0].find_all('p')[6])
EOF

cat > test1.py << EOF
from bs4 import BeautifulSoup

with open("list.htm", "r", encoding="utf-8") as f:
    soup = BeautifulSoup(f, "html.parser")

for i in range(15):
    li = soup.find(id=f"line_u16_{i}")
    data = li.contents[1]
    if "数学" in data.contents[0].string:
        print(data['href'])
EOF

cat > getHtml.py << EOF
def parse_result_file(filename):
    talks = []
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
    blocks = [block.strip() for block in content.split('------------') if block.strip()]

    for block in blocks:
        lines = block.splitlines()
        if len(lines) < 5:
            continue  # 跳过不完整块
        talks.append({
            "link": lines[0],
            "title": lines[1],
            "speaker": lines[2],
            "date": lines[3],
            "abstract": ' '.join(lines[4:])  # 多段摘要合并
        })
    return talks


talks = parse_result_file("result.txt")

html_head = '''
<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<title>讲座信息逐行复制</title>
<style>
body { font-family: Arial, sans-serif; padding: 20px; line-height: 1.6; }
.copy-btn { margin-left: 10px; padding: 3px 8px; border: none; background: #4CAF50; color: white; cursor: pointer; border-radius: 4px; font-size: 12px; }
.section { margin-bottom: 30px; padding: 15px; border: 1px solid #ccc; border-radius: 10px; }
.line { margin: 8px 0; }
</style>
<script>
function copyText(text) {
  navigator.clipboard.writeText(text).catch(function(err) {
    alert("复制失败: " + err);
  });
}
</script>
</head>
<body>
<h1>讲座信息（逐行复制）</h1>
'''

html_body = ""

for talk in talks:
    html_body += '<div class="section">\n'
    for key, label in [
        ("link", "链接"),
        ("title", "标题"),
        ("speaker", "主讲人"),
        ("date", "日期"),
        ("abstract", "摘要")
    ]:
        content = talk[key].replace('"', '&quot;').replace("'", "\\'")
        html_body += f'<div class="line">{label}：{content}<button class="copy-btn" onclick="copyText(\'{content}\')">复制</button></div>\n'
    html_body += '</div>\n'

html_tail = '''
</body>
</html>
'''

with open("talks_from_result_split.html", "w", encoding="utf-8") as f:
    f.write(html_head + html_body + html_tail)

print("✅ 已生成 talks_from_result_split.html，支持 ---- 分块分隔")
EOF
}

getResult(){
if [ ! -f result.txt ]; then
  touch result.txt
fi

for f in $(cat links.txt); do
	wget -q $f -O test.htm
	echo "download form $f"
	echo "$f" >> result.txt
	python test.py | sed -E "s/^.*：//;s/<\/p>//;s/日.*$/日/;" >> result.txt
	echo "stop 1s"
	sleep 1
	echo "------------" >> result.txt
done

python getHtml.py
rm test* links.txt getHtml.py
}

build_python
getMainLink
getListLink
getResult
