<?php
  /**
  * The template for displaying pages
  * Template name: Contact us
  * This is the template that displays all pages by default.
  * Please note that this is the WordPress construct of pages and that
  * other "pages" on your WordPress site will use a different template.
  *
  * @package WordPress
  * @subpackage antuit
  * @since antuit 1.0
  */
  get_header(); ?>
  <script type="text/javascript" src="http://www.google.com/jsapi"></script>
  <script src="http://maps.google.com/maps/api/js?sensor=true"></script>
  <script type="text/javascript">

    var curLat;
    var curLong;

    var geocoder = new google.maps.Geocoder();  
  /* if(navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        curLat  = position.coords.latitude;
        curLong = position.coords.longitude;
      }); */
  
   if(google.loader.ClientLocation) {
      curLat = google.loader.ClientLocation.latitude;
      curLong = google.loader.ClientLocation.longitude;
    }

    // curLat = if(posLat != undefined) ? posLat : geoLat;
   // curLong = if(posLong != undefined) ? posLong : geoLong;

  </script>

  <?php  $banner_img = wp_get_attachment_image_src(get_field('hero_banner_image'), 'full');

  if (have_posts())
    while (have_posts()) : the_post();
  ?>

  <div class="contact-us-page">
    <?php if($banner_img) { ?>
    <div class="banner-img" style="background: url('<?php echo $banner_img[0]; ?>') no-repeat center center; background-size: cover; ">
      <?php } else { ?>
      <div class="banner-img" style="background: url('<?php echo get_template_directory_uri(); ?>/assets/images/default_hero-image.jpg ')center center; background-size: cover; ">
        <?php } ?>

        <div id="map"></div>
      </div>
      <div class="wrapper">
        <div class="main">
          <h2><?php the_title(); ?></h2>

          <?php
          $i = 0;

          $cat_args = array(
            'post_type' => 'contact-us-location',
            'orderby' => 'id',
            'order' => 'ASC',
            'parent' => 0
            );
          $categories = get_categories($cat_args);
          $myCat = $categories->cat_ID;
          $all_contactcat = get_categories('taxonomy=category&hide_empty=0&hierarchical=0&child_of=' . $myCat . '&order=ASC&orderby=term_id');
          $contactcategory = $all_contactcat;

          foreach ($all_contactcat as $value) {
            if($value->category_parent !== 0){
              $counts = false;
              $args = array('post_type' => 'contact-us-location',
                'orderby' => 'title',
                'order' => 'ASC',
                'posts_per_page' => -1,
                'category__and' => array($value->term_id));

              $posts_query = get_posts($args);
              foreach ($posts_query as $post): setup_postdata($post);
              $counts = true;
              $val[$i] = $value->name;
              $result = str_replace(array(',', ' '), '', $val);
              $location_address = wpautop(get_the_content());
              $feature_image = wp_get_attachment_image_src(get_field('hero_banner_image'), 'full');
              $map_lat = get_field('map_lat');
              $map_long = get_field('map_long');

              if($feature_image[0]) {
                $url = $feature_image[0];
              } else {
               // $url = get_template_directory_uri() .'/assets/images/default_hero-image2.jpg';
               $url = '<?php echo $banner_img[0]; ?>';
             }

             if ($val[$i] !== $val[$i - 1]):
              $str .= '<li class="location-category">
            <a class="heading" href="#">' . $val[$i] . '<span class="down-arrow"></span></a>
            <ul class="wrap-sub-locations">';
              endif;
              $str .= '<li class="sub-locations" data-url="' . $url . '" data-lat="'.$map_lat.'" data-long="'.$map_long.'">' .
              get_the_title() . '
            </li>';
            $i++;
            endforeach;
            if($counts) $str .= '</ul></li>';
            wp_reset_postdata();
          }
        }
        ?>
        <div class="locations-form">
          <ul class="contact-locations accordion"><?php echo $str; ?></ul>
          <!--  contact-locations ul ends here-->

          <div class="wrap-address-form">
            <div class="location-address">
              <?php
              $all_contactcat = get_categories('taxonomy=category&hide_empty=0&hierarchical=0&child_of=' . $myCat . '&order=ASC&orderby=slug');
              $contactcategory = $all_contactcat;

              foreach ($all_contactcat as $value) {

                $args = array('post_type' => 'contact-us-location',
                  'orderby' => 'title',
                  'order' => 'ASC',
                  'posts_per_page' => -1,
                  'category__and' => array($value->term_id));

                $posts_query = get_posts($args);
                foreach ($posts_query as $post): setup_postdata($post);
                $location_address = wpautop(get_the_content());
                $locations = get_post_meta($post->ID);
                ?>
                <div class="location-content " data-city="<?php the_title(); ?>">

                  <div class="location-address ">
                    <?php echo $location_address; ?>
                  </div>
                  <div class="view-map">
                    <a class="viewmap learn-antuit-solutions" href="" target="_blank" title="View On Map">View On Map </a>
                    <a href="#Exit" class="exitMap" style="color: #31c297; text-decoration: underline; font-weight:400; display: none;">Exit Map</a>
                  </div>
                </div>

                <?php
                endforeach;
                wp_reset_postdata();
              }
              endwhile;
              ?>
            </div>
            <div class="contact-form">
              <?php
              if (have_posts())
                while (have_posts()) : the_post();
              ?>
              <?php the_content(); ?>
            </div>
          <?php endwhile; ?>

        </div>
        <!--   wrap-address-form block ends here-->

      </div>
      <!-- location-form block ends here-->
    </div>
    <!--main div ends here-->
    <script src="https://maps.googleapis.com/maps/api/js?v=3&amp;key=AIzaSyBcJjWGGDSiNcB3OjLQVd474LAHWukqdPY"> </script>
  </div>
  <!--contact us page code block ends here-->

  <?php get_footer(); ?>

