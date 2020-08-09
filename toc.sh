#!/bin/bash
startText="<!---start--->"
endText="<!---end--->"
isWriteInplace=-i

# 获取对应行号
s=`grep -n ${startText} readme.md | awk '{split($0,a,":"); print a[1]}'`
e=`grep -n ${endText} readme.md | awk '{split($0,a,":"); print a[1]}'`
s=$[$s + 1]
e=$[$e - 1]
echo "startLine :${s} endLine :${e}" 

# 删除行号间的目录
if [ $e -ge $s ];then
    echo "delete ${s} to ${e}"
    sed ${isWriteInplace} '' "${s},${e} d" readme.md
fi

# 遍历获取所有二级标题
allLine=`grep "^[#]\{2\}[^#]" readme.md`
echo "Lines: ${allLine}"

# 去掉前缀
allLine=`echo ${allLine} | sed -e "s/##\ //g"`

# 大写转小写
allLine=`echo ${allLine} | tr '[:upper:]' '[:lower:]'`
echo "trans to lower case: ${allLine}"

# 把所有二级标题组装,如 Leetcode 708 ---> [Leetcode 708](#leetcode-708)
context=(`echo ${allLine} | awk '{split($0,a," "); for(i in a) {print "["a[i]"]""(#"a[i]")"}}'`)

# 把context插入到readme
for ele in ${context[@]};do
    s=`grep -n ${startText} readme.md | awk '{split($0,a,":"); print a[1]}'`
    sed -i '' "${s}a\\
    ${ele}\ \ 
    " readme.md
done