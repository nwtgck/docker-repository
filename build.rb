# TODO: Hard code
dir_path = "repos/nwtgck/piping-server"

Dir.chdir(dir_path){
  system("pwd")
  system("bash", "-xue", "build.bash")
}
