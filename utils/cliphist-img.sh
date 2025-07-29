tmp_dir="/tmp/cliphist-img"

mkdir -p "$tmp_dir"

read -r -d '' prog <<EOF
/^[0-9]+\s<meta http-equiv=/ { next }
match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    path="$tmp_dir/"grp[1]"."grp[3]
    system("echo " grp[1] "\\\\\t | cliphist decode >" path)
    print path
    next
}
EOF

cliphist list | gawk "$prog"
