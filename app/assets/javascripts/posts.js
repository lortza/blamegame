function populateTemplate() {
  document.addEventListener('DOMContentLoaded', function () {
    const entryTypeDropdown = document.getElementById('post_post_type_id');
    const initialPostTypeId = entryTypeDropdown.options[entryTypeDropdown.selectedIndex].value;

    const baseUrl = window.location.origin
    const apiUrl = `${baseUrl}/post_types/${initialPostTypeId}.json`

    const description = document.getElementById('post_description');


    function populateDOM(data) {
      description.value = data.description_template;
    }

    function getPostType(url) {
      fetch(url)
        .then(response => response.json())
        .then(populateDOM)
        .catch(err => console.log(err));
    }

    // Populate description template on pageload
    if(!description){
      getPostType(apiUrl);
    }

    // Populate description template on dropdown change
    entryTypeDropdown.addEventListener('change', function (event) {
      event.preventDefault();

      // Do not overwrite content if some has been populated.
      if(description.value.length == 0){
        const selectedPostTypeId = event.target.value;
        const apiUrl = `${baseUrl}/post_types/${selectedPostTypeId}.json`

        getPostType(apiUrl);
      }
    })
  });
}
