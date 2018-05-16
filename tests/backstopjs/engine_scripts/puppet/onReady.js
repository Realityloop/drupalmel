module.exports = async (page, scenario, vp) => {
  console.log('SCENARIO > ' + scenario.label);
  await require('./clickAndHoverHelper')(page, scenario);

  // Set events__event content.
  const eventsTitles = await page.$$('.component__events__event');
  eventsTitles.forEach(handle => {

    // Set title.
    handle.$eval('.title', el => {
      return el.innerHTML = 'Drupal Melbourne Meetup';
    });

    // Set date.
    handle.$eval('.date', el => {
      return el.innerHTML = '17/05';
    });

    // Set time.
    handle.$eval('.time', el => {
      return el.innerHTML = '18:00';
    });

  });

  // Set the active event title.
  await page.$eval('.component__events__event--active .title', el => {
    return el.innerHTML = 'Drupal Melbourne Meetup with guest Michael Schmid';
  });
};
