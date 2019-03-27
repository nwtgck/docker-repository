# Requirements
# * ghr: https://github.com/tcnksm/ghr

# TODO: Hard code
repo_name="nwtgck/piping-server"
dir_path = File.join("repos", repo_name)

Dir.chdir(dir_path){
  system("pwd")
  system("bash", "-xue", "build.bash")
  # TODO: Check whether dist exists
  # Create a tag
  git_tag = "#{repo_name}/dummy_commit"
  system("ghr", git_tag, "dist")
}

# # Move dist to project dist to prepare publish
# system("mv", File.join(dir_path, "dist"), "dist")
